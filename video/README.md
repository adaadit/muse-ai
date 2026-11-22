# Pipeline Video 3D — cara pakai

Alur gratis pengganti render berbayar:

1. **Muse membuat klip 3D** (klip pendek per adegan) dan **file narasi** (suara voiceover) di chat.
2. **Kamu upload** klip ke folder `video/input/clips/` dan narasi ke `video/input/narration/`
   di repo ini — bisa langsung dari halaman GitHub (tombol **Add file → Upload files**),
   tidak perlu install apa pun.
3. **GitHub Actions merender otomatis**: semua klip digabung urut nama file, narasi dicampur
   di atasnya, hasilnya muncul di `video/output/final.mp4` dan juga sebagai artifact
   di tab **Actions**.

## Aturan penamaan

- Klip: `01.mp4`, `02.mp4`, `03.mp4`, … — urutan gabung mengikuti urutan nama.
  Format lain yang diterima: `.mov`, `.webm`. Semua klip otomatis diseragamkan
  ke 1280x720, 30fps.
- Narasi: `01.mp3`, `02.mp3`, … — digabung urut nama, lalu dicampur di atas audio klip
  (audio bawaan klip diturunkan ke 35% agar suara narator jelas).

## Menjalankan manual

Tab **Actions** → **Render Video 3D** → **Run workflow**. Bila folder klip masih kosong,
pipeline membuat klip demo uji agar bisa dipastikan jalurnya bekerja.

## Catatan

- Render berjalan di server GitHub (repo publik: gratis dalam batas wajar pemakaian).
- Jangan upload file rahasia ke repo ini — repo ini publik.
