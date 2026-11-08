
# MyTask App

MyTask App adalah aplikasi sederhana berbasis Flutter
yang digunakan untuk mencatat dan mengelola tugas kuliah
mahasiswa.

## Teknologi

- Flutter 3.27.2
- Dart 3.6.1
- Visual Studio Code
- Google Chrome (Flutter Web)
- Git dan GitHub

## Fitur Aplikasi

1. Menampilkan daftar tugas kuliah.
2. Menambahkan tugas baru.
3. Mengubah status tugas menjadi Selesai.
4. Menghapus tugas dengan konfirmasi.
5. Melakukan validasi input yang kosong.
6. Menampilkan antarmuka sederhana dan responsif.

## Informasi Tugas

Setiap tugas memiliki:
- Judul tugas
- Nama mata kuliah
- Deadline
- Status pengerjaan

## Struktur Project

lib/
├── main.dart
├── models/
│   └── task.dart
└── pages/
    ├── home_page.dart
    └── add_task_page.dart

## Cara Menjalankan

Pastikan Flutter SDK sudah terpasang.

```bash
flutter pub get
flutter run -d chrome
```

## Pengujian

```bash
flutter analyze
flutter test
```

## Penyimpanan Data

Aplikasi saat ini menggunakan state dalam memori.
Data tugas akan kembali ke kondisi awal ketika
aplikasi dimulai ulang.

## Repository

https://github.com/fikriandarlan/mytask-app-flutter