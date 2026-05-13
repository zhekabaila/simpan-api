# 📋 TESTING CHECKLIST - SIBANSOS-QR API

**Tanggal Testing:** ******\_\_\_******  
**Tester:** ******\_\_\_******  
**Versi:** 1.0

---

## 🔐 1. AUTENTIKASI (REGISTER & LOGIN)

### Register (Daftar Akun Baru)

| No  | Fitur           | Langkah                           | Hasil Diharapkan        | Status |
| --- | --------------- | --------------------------------- | ----------------------- | ------ |
| 1.1 | Email baru      | Masukkan email belum terdaftar    | Email diterima          | [ ]      |
| 1.2 | Email sudah ada | Masukkan email yang sudah ada     | Muncul pesan error      | [ ]      |
| 1.3 | Email invalid   | Masukkan email tidak valid (xxx@) | Pesan error format      | [ ]      |
| 1.4 | Password        | Masukkan password ≥ 8 karakter    | Password diterima       | [ ]      |
| 1.5 | Password pendek | Masukkan password < 8 karakter    | Pesan error             | [ ]      |
| 1.6 | Daftar berhasil | Klik tombol "Daftar"              | Akun dibuat, auto login | [ ]      |

### Login (Masuk Akun)

| No  | Fitur                  | Langkah                     | Hasil Diharapkan                  | Status |
| --- | ---------------------- | --------------------------- | --------------------------------- | ------ |
| 2.1 | Email & password benar | Masukkan email dan password | Login berhasil                    | [ ]      |
| 2.2 | Email salah            | Email tidak terdaftar       | Pesan "Email atau password salah" | [ ]      |
| 2.3 | Password salah         | Password tidak sesuai       | Pesan error                       | [ ]      |
| 2.4 | Logout                 | Klik tombol logout          | Logout berhasil                   | [ ]      |

---

## 👤 2. PROFIL MASYARAKAT

### Edit Profil

| No  | Fitur                  | Langkah                      | Hasil Diharapkan          | Status |
| --- | ---------------------- | ---------------------------- | ------------------------- | ------ |
| 3.1 | Buka profil            | Click menu "Profil"          | Form profil terbuka       | [ ]      |
| 3.2 | Input NIK              | Masukkan NIK 16 digit        | NIK tersimpan             | [ ]      |
| 3.3 | Input alamat           | Masukkan alamat lengkap      | Alamat tersimpan          | [ ]      |
| 3.4 | Input no telepon       | Masukkan no WhatsApp         | No telepon tersimpan      | [ ]      |
| 3.5 | Input status pekerjaan | Pilih dari dropdown          | Status tersimpan          | [ ]      |
| 3.6 | Input penghasilan      | Masukkan penghasilan bulanan | Penghasilan tersimpan     | [ ]      |
| 3.7 | Simpan profil          | Klik "Simpan"                | Notifikasi success muncul | [ ]      |
| 3.8 | Data tersimpan         | Refresh halaman              | Data profil masih ada     | [ ]      |

### Upload Foto Rumah

| No  | Fitur              | Langkah            | Hasil Diharapkan             | Status |
| --- | ------------------ | ------------------ | ---------------------------- | ------ |
| 4.1 | Upload foto        | Klik "Upload Foto" | File picker terbuka          | [ ]      |
| 4.2 | Foto JPG/PNG       | Pilih file JPG/PNG | Foto upload berhasil         | [ ]      |
| 4.3 | Format salah       | Upload PDF/TXT     | Pesan "Format tidak valid"   | [ ]      |
| 4.4 | Foto terlalu besar | Upload > 5MB       | Pesan "Ukuran terlalu besar" | [ ]      |
| 4.5 | Lihat foto         | Scroll list        | Semua foto tampil            | [ ]      |
| 4.6 | Hapus foto         | Klik icon hapus    | Foto hilang dari list        | [ ]      |

---

## 📝 3. PENGAJUAN BANSOS

### Submit Pengajuan

| No  | Fitur                | Langkah                              | Hasil Diharapkan                  | Status |
| --- | -------------------- | ------------------------------------ | --------------------------------- | ------ |
| 5.1 | Menu pengajuan       | Click "Ajukan Bansos"                | Form pengajuan terbuka            | [ ]      |
| 5.2 | Profil belum lengkap | Submit tanpa profil lengkap          | Pesan "Lengkapi profil"           | [ ]      |
| 5.3 | Input alasan         | Masukkan alasan pengajuan            | Alasan diterima                   | [ ]      |
| 5.4 | Submit pengajuan     | Klik "Ajukan"                        | Pengajuan berhasil dibuat         | [ ]      |
| 5.5 | Nomor pengajuan      | Lihat nomor pengajuan                | Nomor tampil (PB-2025-xxxxx)      | [ ]      |
| 5.6 | Status awal          | Lihat status pengajuan               | Status: "Menunggu"                | [ ]      |
| 5.7 | Cegah duplikat       | Submit pengajuan 2 saat status aktif | Pesan "Sudah ada pengajuan aktif" | [ ]      |

### Cek Status Pengajuan

| No  | Fitur         | Langkah                  | Hasil Diharapkan               | Status |
| --- | ------------- | ------------------------ | ------------------------------ | ------ |
| 6.1 | Menu status   | Click "Status Pengajuan" | Halaman status terbuka         | [ ]      |
| 6.2 | Status awal   | Lihat status             | Status: "Menunggu Persetujuan" | [ ]      |
| 6.3 | Update status | Setelah admin approve    | Status berubah "Disetujui"     | [ ]      |
| 6.4 | Lihat tanggal | Lihat tanggal approval   | Tanggal tampil                 | [ ]      |

---

## 🎁 4. QR CODE & NOTIFIKASI

### QR Code

| No  | Fitur               | Langkah                   | Hasil Diharapkan          | Status |
| --- | ------------------- | ------------------------- | ------------------------- | ------ |
| 7.1 | Menu QR             | Click "QR Code Saya"      | Halaman QR terbuka        | [ ]      |
| 7.2 | QR belum aktif      | Cek sebelum approval      | Pesan "QR belum tersedia" | [ ]      |
| 7.3 | QR setelah approval | Cek setelah admin approve | QR Code tampil            | [ ]      |
| 7.4 | Download QR         | Klik download             | File QR ter-download      | [ ]      |
| 7.5 | Tampilkan QR        | Klik "Tampilkan"          | QR diperbesar untuk scan  | [ ]      |

### Notifikasi

| No  | Fitur               | Langkah            | Hasil Diharapkan         | Status |
| --- | ------------------- | ------------------ | ------------------------ | ------ |
| 8.1 | Notifikasi WhatsApp | Admin approve      | Notifikasi WA terkirim   | [ ]      |
| 8.2 | Isi notifikasi      | Buka notifikasi    | Ada info approval        | [ ]      |
| 8.3 | Menu notifikasi     | Click "Notifikasi" | Daftar notifikasi tampil | [ ]      |
| 8.4 | Baca notifikasi     | Click notifikasi   | Mark sebagai dibaca      | [ ]      |
| 8.5 | Hapus notifikasi    | Klik icon hapus    | Notifikasi hilang        | [ ]      |

---

## 👨‍💼 5. PETUGAS - DISTRIBUSI BANSOS

### Lihat Penugasan

| No  | Fitur             | Langkah                | Hasil Diharapkan                      | Status |
| --- | ----------------- | ---------------------- | ------------------------------------- | ------ |
| 9.1 | Dashboard petugas | Login sebagai petugas  | Dashboard terbuka                     | [ ]      |
| 9.2 | Menu penugasan    | Click "Penugasan Saya" | List penugasan tampil                 | [ ]      |
| 9.3 | Detail penugasan  | Click penugasan        | Detail terbuka                        | [ ]      |
| 9.4 | Daftar penerima   | Scroll list            | Semua penerima tampil                 | [ ]      |
| 9.5 | Status distribusi | Lihat status           | Status: "Belum Diterima" atau "Sudah" | [ ]      |

### Scan QR Code

| No   | Fitur             | Langkah                     | Hasil Diharapkan                | Status |
| ---- | ----------------- | --------------------------- | ------------------------------- | ------ |
| 10.1 | Tombol scan       | Klik "Scan QR Code"         | Camera/scanner terbuka          | [ ]      |
| 10.2 | Scan QR valid     | Arahkan ke QR penerima      | QR terbaca berhasil             | [ ]      |
| 10.3 | Data penerima     | Setelah scan                | Nama, alamat, detail tampil     | [ ]      |
| 10.4 | Konfirmasi terima | Klik "Konfirmasi Terima"    | Status berubah "Sudah Diterima" | [ ]      |
| 10.5 | Pesan sukses      | Setelah scan                | Pesan "Distribusi berhasil"     | [ ]      |
| 10.6 | QR duplikat       | Scan QR yang sudah tercatat | Pesan "Sudah diterima"          | [ ]      |

### Upload Dokumentasi

| No   | Fitur             | Langkah                     | Hasil Diharapkan           | Status |
| ---- | ----------------- | --------------------------- | -------------------------- | ------ |
| 11.1 | Menu dokumentasi  | Click "Dokumentasi"         | Halaman upload terbuka     | [ ]      |
| 11.2 | Pilih jenis       | Pilih "Foto" atau "Catatan" | Jenis terpilih             | [ ]      |
| 11.3 | Upload foto       | Pilih file foto             | Foto upload berhasil       | [ ]      |
| 11.4 | Preview foto      | Lihat di list               | Foto tampil dengan preview | [ ]      |
| 11.5 | Input catatan     | Ketik catatan               | Catatan diterima           | [ ]      |
| 11.6 | Simpan catatan    | Klik simpan                 | Catatan tersimpan          | [ ]      |
| 11.7 | Hapus dokumentasi | Klik icon hapus             | File hilang dari list      | [ ]      |

---

## 📅 6. ADMIN - KELOLA PERIODE

### Create Periode Baru

| No   | Fitur             | Langkah                | Hasil Diharapkan        | Status |
| ---- | ----------------- | ---------------------- | ----------------------- | ------ |
| 12.1 | Menu periode      | Click "Periode Bansos" | Halaman periode terbuka | [ ]      |
| 12.2 | Tombol buat       | Klik "Buat Periode"    | Form periode terbuka    | [ ]      |
| 12.3 | Input nama        | Masukkan nama periode  | Nama diterima           | [ ]      |
| 12.4 | Input tgl mulai   | Pilih tanggal mulai    | Tanggal diterima        | [ ]      |
| 12.5 | Input tgl selesai | Pilih tanggal selesai  | Tanggal diterima        | [ ]      |
| 12.6 | Simpan periode    | Klik "Buat"            | Periode dibuat berhasil | [ ]      |
| 12.7 | Status awal       | Lihat status periode   | Status: "Akan Datang"   | [ ]      |

### Kelola Periode

| No   | Fitur              | Langkah                              | Hasil Diharapkan     | Status |
| ---- | ------------------ | ------------------------------------ | -------------------- | ------ |
| 13.1 | Lihat list periode | Scroll daftar                        | Semua periode tampil | [ ]      |
| 13.2 | Edit periode       | Klik icon edit                       | Form edit terbuka    | [ ]      |
| 13.3 | Update data        | Ubah data periode                    | Data update berhasil | [ ]      |
| 13.4 | Mulai distribusi   | Klik "Mulai Distribusi"              | Status: "Aktif"      | [ ]      |
| 13.5 | Selesai periode    | Klik "Selesai"                       | Status: "Selesai"    | [ ]      |
| 13.6 | Hapus periode      | Klik icon hapus (status Akan Datang) | Periode dihapus      | [ ]      |

### Tugaskan Petugas

| No   | Fitur              | Langkah                  | Hasil Diharapkan          | Status |
| ---- | ------------------ | ------------------------ | ------------------------- | ------ |
| 14.1 | Menu penugasan     | Click "Tugaskan Petugas" | Halaman penugasan terbuka | [ ]      |
| 14.2 | Pilih petugas      | Click dropdown petugas   | List petugas muncul       | [ ]      |
| 14.3 | Pilih periode      | Click dropdown periode   | List periode muncul       | [ ]      |
| 14.4 | Tugaskan           | Klik "Tugaskan"          | Penugasan dibuat berhasil | [ ]      |
| 14.5 | Lihat penugasan    | Scroll list penugasan    | Penugasan tampil          | [ ]      |
| 14.6 | Notifikasi petugas | Cek WA petugas           | Petugas dapat notifikasi  | [ ]      |

---

## ✅ 7. ADMIN - KELOLA PENGAJUAN

### Lihat Daftar Pengajuan

| No   | Fitur          | Langkah                          | Hasil Diharapkan          | Status |
| ---- | -------------- | -------------------------------- | ------------------------- | ------ |
| 15.1 | Menu pengajuan | Click "Kelola Pengajuan"         | Halaman pengajuan terbuka | [ ]      |
| 15.2 | Lihat semua    | Scroll daftar                    | Semua pengajuan tampil    | [ ]      |
| 15.3 | Filter status  | Pilih status (Menunggu/Ditinjau) | List ter-filter           | [ ]      |
| 15.4 | Search nama    | Ketik nama penerima              | Hasil ter-filter nama     | [ ]      |
| 15.5 | Search NIK     | Ketik NIK                        | Hasil ter-filter NIK      | [ ]      |

### Detail & Persetujuan Pengajuan

| No   | Fitur              | Langkah                    | Hasil Diharapkan                       | Status |
| ---- | ------------------ | -------------------------- | -------------------------------------- | ------ |
| 16.1 | Lihat detail       | Click salah satu pengajuan | Halaman detail terbuka                 | [ ]      |
| 16.2 | Data pemohon       | Lihat data                 | Nama, NIK, alamat tampil               | [ ]      |
| 16.3 | Foto rumah         | Lihat galeri               | Semua foto tampil                      | [ ]      |
| 16.4 | Tombol setujui     | Click "Setujui"            | Popup konfirmasi muncul                | [ ]      |
| 16.5 | Setujui            | Klik "Ya"                  | Status: "Disetujui", QR dibuat         | [ ]      |
| 16.6 | Notifikasi pemohon | Cek WA penerima            | Penerima dapat notifikasi              | [ ]      |
| 16.7 | Tombol tolak       | Click "Tolak"              | Form alasan tolak muncul               | [ ]      |
| 16.8 | Input alasan       | Ketik alasan penolakan     | Alasan diterima                        | [ ]      |
| 16.9 | Tolak & notifikasi | Klik "Tolak"               | Status: "Ditolak", notifikasi terkirim | [ ]      |

---

## 📊 8. ADMIN - MONITORING

### Statistik Overview

| No   | Fitur               | Langkah             | Hasil Diharapkan       | Status |
| ---- | ------------------- | ------------------- | ---------------------- | ------ |
| 17.1 | Dashboard admin     | Login sebagai admin | Dashboard terbuka      | [ ]      |
| 17.2 | Kartu statistik     | Lihat overview      | Kartu statistik tampil | [ ]      |
| 17.3 | Total pengajuan     | Lihat card          | Angka total tampil     | [ ]      |
| 17.4 | Pengajuan disetujui | Lihat card          | Angka disetujui tampil | [ ]      |
| 17.5 | Pengajuan ditolak   | Lihat card          | Angka ditolak tampil   | [ ]      |
| 17.6 | Pengajuan menunggu  | Lihat card          | Angka menunggu tampil  | [ ]      |

### Progress Distribusi

| No   | Fitur             | Langkah                       | Hasil Diharapkan       | Status |
| ---- | ----------------- | ----------------------------- | ---------------------- | ------ |
| 18.1 | Menu monitoring   | Click "Monitoring Distribusi" | Halaman terbuka        | [ ]      |
| 18.2 | Pilih periode     | Click dropdown                | List periode terbuka   | [ ]      |
| 18.3 | Progress bar      | Lihat progress                | Progress tampil        | [ ]      |
| 18.4 | Persentase        | Lihat persentase              | Menampilkan % selesai  | [ ]      |
| 18.5 | Daftar distribusi | Scroll list                   | List distribusi tampil | [ ]      |
| 18.6 | Filter kota       | Pilih kota                    | List ter-filter kota   | [ ]      |
| 18.7 | Filter status     | Pilih status penerimaan       | List ter-filter status | [ ]      |

### Peta Distribusi

| No   | Fitur         | Langkah                 | Hasil Diharapkan             | Status |
| ---- | ------------- | ----------------------- | ---------------------------- | ------ |
| 19.1 | Menu peta     | Click "Peta Distribusi" | Halaman peta terbuka         | [ ]      |
| 19.2 | Tampil peta   | Lihat peta              | Peta area tampil             | [ ]      |
| 19.3 | Marker lokasi | Lihat marker            | Marker lokasi tampil         | [ ]      |
| 19.4 | Info marker   | Hover ke marker         | Nama, alamat penerima tampil | [ ]      |

---

## 👥 9. ADMIN - KELOLA PENGGUNA

| No   | Fitur               | Langkah                 | Hasil Diharapkan           | Status |
| ---- | ------------------- | ----------------------- | -------------------------- | ------ |
| 20.1 | Menu pengguna       | Click "Kelola Pengguna" | Halaman pengguna terbuka   | [ ]      |
| 20.2 | Lihat daftar        | Scroll list             | Semua pengguna tampil      | [ ]      |
| 20.3 | Filter role         | Pilih role              | List ter-filter role       | [ ]      |
| 20.4 | Filter status aktif | Pilih status            | List ter-filter status     | [ ]      |
| 20.5 | Tambah pengguna     | Click "Tambah Pengguna" | Form tambah terbuka        | [ ]      |
| 20.6 | Reset password      | Click "Reset Password"  | Form reset terbuka         | [ ]      |
| 20.7 | Nonaktifkan user    | Click "Nonaktifkan"     | Status user: "Tidak Aktif" | [ ]      |

---

## 📋 HASIL TESTING

**Total Test Cases:** **\_** / **\_** PASS  
**Pass Rate:** **\_\_** %  
**Issue Ditemukan:** **\_**

### Issues Found

| No  | Fitur | Masalah | Severity    | Status |
| --- | ----- | ------- | ----------- | ------ |
| 1   |       |         | 🔴 CRITICAL | [ ]      |
| 2   |       |         | 🟠 MAJOR    | [ ]      |
| 3   |       |         | 🟡 MINOR    | [ ]      |

### Testing Environment

**Testing Date:** ******\_\_\_******  
**Tester:** ******\_\_\_******  
**Base URL:** ******\_\_\_******  
**Database:** ******\_\_\_******

### Catatan

```
[Tuliskan catatan testing Anda di sini]
```

---

## ✅ Sign-Off

**QA Lead:** ******\_\_\_****** **Tanggal:** ******\_\_\_******

**Dev Lead:** ******\_\_\_****** **Tanggal:** ******\_\_\_******

**Approval:** ******\_\_\_****** **Tanggal:** ******\_\_\_******

---

**Versi:** 1.0 | **Generated:** 2026-05-13
