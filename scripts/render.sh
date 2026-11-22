#!/usr/bin/env bash
# Render pipeline video 3D untuk repo muse-ai.
# Cara kerja:
#   1. Ambil semua klip di video/input/clips/ (urut nama file: 01.mp4, 02.mp4, ...)
#   2. Normalisasi semua klip ke 1280x720, 30fps, audio stereo 44.1kHz
#   3. Gabungkan jadi satu video
#   4. Kalau ada narasi di video/input/narration/ (*.mp3, urut nama), gabungkan
#      narasi lalu campur di atas audio klip (audio klip diturunkan ke 35%)
#   5. Hasil akhir: video/output/final.mp4
# Kalau folder klip kosong, skrip membuat klip DEMO uji (pola warna + bunyi)
# supaya pipeline tetap terbukti jalan.
set -euo pipefail

CLIPS_DIR="video/input/clips"
NARR_DIR="video/input/narration"
OUT_DIR="video/output"
WORK="video/.work"
mkdir -p "$OUT_DIR" "$WORK"
rm -f "$WORK"/*.mp4 "$WORK"/list.txt "$WORK"/narr-list.txt 2>/dev/null || true

VF="scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,fps=30,format=yuv420p"

shopt -s nullglob
clips=( "$CLIPS_DIR"/*.mp4 "$CLIPS_DIR"/*.mov "$CLIPS_DIR"/*.webm )
IFS=$'\n' clips=( $(printf '%s\n' "${clips[@]}" | sort) )
unset IFS

if [ ${#clips[@]} -eq 0 ]; then
  echo "== Mode DEMO: folder klip kosong, membuat klip uji dengan ffmpeg =="
  ffmpeg -y -f lavfi -i "testsrc2=size=1280x720:rate=30:duration=6" \
         -f lavfi -i "sine=frequency=440:duration=6" \
         -c:v libx264 -pix_fmt yuv420p -c:a aac -shortest "$WORK/demo.mp4"
  clips=( "$WORK/demo.mp4" )
fi

echo "== Menormalisasi ${#clips[@]} klip =="
i=0
: > "$WORK/list.txt"
for clip in "${clips[@]}"; do
  i=$((i+1))
  out="$WORK/norm_$(printf '%02d' "$i").mp4"
  if ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "$clip" | grep -q .; then
    ffmpeg -y -i "$clip" -vf "$VF" -af "aresample=44100" \
      -c:v libx264 -c:a aac -shortest "$out"
  else
    ffmpeg -y -i "$clip" -f lavfi -i "anullsrc=channel_layout=stereo:sample_rate=44100" \
      -vf "$VF" -map 0:v -map 1:a -c:v libx264 -c:a aac -shortest "$out"
  fi
  echo "file '$PWD/$out'" >> "$WORK/list.txt"
done

echo "== Menggabungkan klip =="
ffmpeg -y -f concat -safe 0 -i "$WORK/list.txt" -c copy "$WORK/merged.mp4"

narr=( "$NARR_DIR"/*.mp3 )
IFS=$'\n' narr=( $(printf '%s\n' "${narr[@]}" | sort) )
unset IFS

if [ ${#narr[@]} -gt 0 ]; then
  echo "== Mencampur ${#narr[@]} file narasi di atas audio klip =="
  : > "$WORK/narr-list.txt"
  for n in "${narr[@]}"; do
    echo "file '$PWD/$n'" >> "$WORK/narr-list.txt"
  done
  ffmpeg -y -f concat -safe 0 -i "$WORK/narr-list.txt" -c:a libmp3lame "$WORK/narration.mp3"
  ffmpeg -y -i "$WORK/merged.mp4" -i "$WORK/narration.mp3" \
    -filter_complex "[0:a]volume=0.35[bg];[bg][1:a]amix=inputs=2:duration=first[aout]" \
    -map 0:v -map "[aout]" -c:v copy -c:a aac -shortest "$OUT_DIR/final.mp4"
else
  echo "== Tanpa narasi: hasil gabungan langsung menjadi final =="
  cp "$WORK/merged.mp4" "$OUT_DIR/final.mp4"
fi

echo "== Selesai: $OUT_DIR/final.mp4 =="
ffprobe -v error -show_entries format=duration,size -of default=noprint_wrappers=1 "$OUT_DIR/final.mp4" || true
