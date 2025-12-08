# PetFriend: Ringkasan Proyek

## Deskripsi Singkat
- Aplikasi Flutter bertema virtual bear companion. Pengguna bisa melihat status beruang, memberi makan, bermain, merawat, dan bercakap-cakap secara sederhana.
- Tampilan awal: `lib/main.dart` memuat `SplashPage` lalu `HomePage`.
- Halaman utama: `home_page.dart` (dashboard dan aksi cepat), `chat_page.dart` (chat rule-based), `pet_care_page.dart` (tab tugas harian, toko makanan, aktivitas), `profile_page.dart` (profil, statistik, pencapaian).

## Arsitektur & Data
- State disimpan lokal per halaman dengan `setState`; tidak ada penyimpanan persistensi atau backend.
- Semua data (tugas, makanan, aktivitas, statistik, coins) adalah list dummy yang dibuat di state dan hanya hidup selama sesi aplikasi.
- Tidak ada manajemen state global; navigasi memakai `Navigator` dan `MaterialPageRoute`/`PageRouteBuilder`.
- Aset: `assets/bear.png` terdaftar di `pubspec.yaml`.
- Dependensi minimal: Flutter SDK dan `cupertino_icons` (tidak ada paket eksternal lain).

## Fitur Utama Saat Ini
- Splash animasi sederhana, tema Material3 bernuansa coklat.
- Dashboard dengan status energi/kebahagiaan/kesehatan dan tombol aksi cepat (feed/play/heal/more).
- Chat simulasi berbasis rule sederhana (deteksi kata kunci, respons acak ringan).
- Pusat perawatan: daftar tugas harian, toko makanan memakai coins, aktivitas dengan dialog konfirmasi dan riwayat.
- Profil pengguna: edit nama/email secara lokal, statistik dummy, pencapaian dummy, toggle setting placeholder.

## Batasan & Kekurangan
- Tidak ada backend, LLM, atau AI nyata: chat hanya rule-based hardcoded.
- Tidak ada persistensi (local storage/database); coins, progres tugas, profil, dan statistik hilang saat aplikasi ditutup.
- Tidak ada autentikasi atau multi-user; semua data bersifat lokal dan tunggal.
- Tidak ada validasi input berarti pada profil; perubahan langsung diset tanpa pengecekan.
- Tidak ada tes otomatis (unit/widget/integration) dan belum ada CI.
- Beberapa string emoji di kode tampil terdistorsi (encoding) sehingga UI bisa menampilkan karakter aneh.
- Error handling terbatas; sebagian besar aksi hanya menampilkan SnackBar tanpa fallback lanjutan.
- Aksesibilitas belum diperhatikan (label semantik, kontras, dukungan screen reader).

## Ide Pengembangan Lanjut
- Integrasi backend/LLM untuk chat nyata dan penyimpanan progres (coins, tugas, statistik).
- Tambahkan persistensi lokal (mis. `shared_preferences`, `hive`, atau `sqflite`) untuk menjaga state antar sesi.
- Perbaiki encoding emoji atau ganti dengan ikon/material assets.
- Tambah manajemen state yang lebih terstruktur (Provider/BLoC/Riverpod) jika kompleksitas bertambah.
- Tambah autentikasi dasar jika diperlukan multi-user.
- Lengkapi test suite (unit untuk logika, widget untuk UI, integration untuk alur utama) dan setup CI.
