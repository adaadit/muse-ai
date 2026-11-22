# muse-ai

Repo otomasi untuk Muse — ruang kerja bersama antara **Muhammad Aditya** (Marketers Digital Agency / PT Infinite Inovasi Nusantara) dan Muse, asisten AI-nya.

## Untuk apa repo ini

- Menyimpan skrip dan otomasi yang dibuat Muse untuk membantu pekerjaan Muhammad Aditya.
- Menyimpan konfigurasi, template, dan dokumentasi alur kerja yang dipakai berulang.
- Menjadi tempat kolaborasi: Muse dapat membaca, mengusulkan, dan (dengan persetujuan) menulis perubahan di sini.

## Aturan main

1. **Tidak ada rahasia di repo ini.** Jangan pernah commit password, API key, App Secret, access token, atau kode verifikasi — dalam bentuk apa pun. Gunakan file `.env` lokal (sudah diabaikan lewat `.gitignore`) atau penyimpanan kredensial yang aman.
2. Perubahan oleh Muse dilakukan lewat commit yang jelas pesannya, dan untuk perubahan besar lewat *pull request* agar bisa ditinjau dulu.
3. Repo ini **publik** — jangan taruh data klien, data pribadi, atau dokumen internal perusahaan di sini.

## Pipeline video 3D (gratis)

Repo ini punya jalur render video otomatis berbasis GitHub Actions:

- Muse membuat klip 3D dan narasi suara di chat.
- Klip di-upload ke `video/input/clips/`, narasi ke `video/input/narration/`.
- GitHub Actions menggabungkan semuanya menjadi `video/output/final.mp4`.

Panduan lengkapnya ada di [`video/README.md`](video/README.md).

## Status

- 2026-11-22 — Repo dibuat dan dihubungkan ke Muse; commit awal berisi README ini dan `.gitignore`.
- 2026-11-22 — Pipeline render video 3D (GitHub Actions + ffmpeg) ditambahkan.
