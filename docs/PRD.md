# PRD Laundryin (v3, gabungan PRD v1 + v2, siap dibaca agen)

Dokumen ini adalah **sumber kebenaran produk**. Desain visual ada di Figma (lihat bagian 3);
jika dokumen ini dan Figma berbeda soal tampilan, **Figma menang**; soal perilaku dan data, **dokumen ini menang**.
Setiap kebutuhan punya ID (contoh `C-03`) agar bisa dirujuk di kode, tes, dan commit.

Prioritas: **P0** wajib MVP, **P1** sebaiknya ada di MVP, **P2** fase 2.

---

## 1. Ringkasan Produk

Laundryin: aplikasi mobile Flutter (Android dulu, iOS menyusul) untuk **satu usaha laundry** dengan layanan
antar-jemput. Satu aplikasi melayani tiga role (Customer, Kurir, Kasir); dashboard web Admin menyusul di fase 2.

- Bahasa antarmuka: **Indonesia**, nada santai, sapaan "kamu".
- Mata uang: Rupiah, bilangan bulat.
- Target MVP: satu outlet, satu kota.

**Di luar lingkup MVP (P2):** dashboard web Admin, multi-outlet, langganan bulanan, poin loyalitas, chat, dark mode, iOS, cetak nota Bluetooth.

**Metrik keberhasilan MVP**
- Customer menyelesaikan pesanan pertama dalam kurang dari 3 menit.
- Crash-free sessions di atas 99,5% pada beta test.
- 50 order uji selesai tanpa order hilang atau status salah.

---

## 2. Role dan Hak Akses

Satu akun satu role. Role staf (Kurir, Kasir) ditetapkan Admin/pemilik, bukan dipilih sendiri.
Hak akses **dipaksakan di server** (Firestore Security Rules), bukan hanya disembunyikan di UI.

| Role | Boleh | Tidak boleh |
| --- | --- | --- |
| Customer | Buat dan batalkan pesanan sendiri (sebelum Dijemput), lihat riwayat sendiri, bayar, beri rating | Lihat order orang lain, ubah status, ubah harga |
| Kurir | Lihat tugas yang ditugaskan kepadanya, update status jemput dan antar, unggah foto bukti | Ubah harga, lihat order yang bukan tugasnya |
| Kasir | Lihat semua order outlet, input berat dan item, update status proses, tugaskan kurir, catat pembayaran tunai | Hapus order, ubah daftar harga master |
| Admin (P2) | Semua hal di atas ditambah kelola layanan, harga, pegawai, promo, laporan | – |

---

## 3. Sumber Desain (Figma)

- File Figma: https://www.figma.com/file/hTNJrWxJ4pajqdaCyf92HF/Mobile-Design-System-for-Laundryin
- Halaman Figma: `Components` (semua komponen dan varian), `Screens` (layar).
- Frame desain 390 × 844. Header selalu di bawah area status bar 54 px (di Flutter: `SafeArea`).

### 3.1 Token desain

| Token | Nilai |
| --- | --- |
| Primary / Dark / Light | `#0EA5E9` / `#0369A1` / `#E0F2FE` |
| Accent | `#14B8A6` |
| Background / Surface | `#F8FAFC` / `#FFFFFF` |
| Teks utama / sekunder | `#0F172A` / `#64748B` |
| Border | `#E2E8F0` |
| Success / Warning / Error | `#22C55E` / `#F59E0B` / `#EF4444` |
| Tint biru / ungu / amber / tosca | `#E0F2FE` / `#F3E8FF` / `#FEF3C7` / `#CCFBF1` (perkiraan, ambil nilai pasti dari Figma) |
| Gradien brand | `#38BDF8` → `#0369A1` (perkiraan, ambil dari Figma) |
| Huruf | Plus Jakarta Sans: H1 28 Bold, H2 22 Bold, H3 18 SemiBold, Body 14, Caption 12 (minimum), Button 16 SemiBold |
| Spasi | grid 8 pt, padding layar 20 |
| Radius | kartu 16, tombol dan input 12 |
| Bayangan | `shadow.soft` (biru lembut, blur 16–24) |

Aturan: **tidak ada warna, ukuran, atau jarak yang ditulis langsung di widget**; semua dari tema.
Nilai pasti selalu diambil dari Figma (Styles/Variables) lewat MCP, bukan ditebak dari dokumen ini.

### 3.2 Katalog komponen (27) dan widget Flutter

Penamaan Figma: `Grup/Nama/Varian`. Widget berada di `lib/core/widgets/`.

| Komponen | Varian dan state | Widget |
| --- | --- | --- |
| BrandMark | besar (putih di atas gradien), kecil (gradien) | `BrandMark` |
| AppBar | logo + aksi; kembali + logo; kembali melayang di atas foto | `LaundryAppBar` |
| BottomNav | 4 tab (Beranda, Pesanan, Promo, Profil), aktif, badge | `LaundryBottomNav` |
| PageIndicator | pil aktif, titik tidak aktif | `PageIndicator` |
| SectionHeader | judul + tautan aksi; tanpa tautan | `SectionHeader` |
| StickyActionBar | harga + tombol; disabled; loading | `StickyActionBar` |
| Button/Primary | lebar penuh, ikon kanan; default, pressed, disabled, loading | `AppButton.primary` |
| Button/Outline | ikon kiri; default, pressed, disabled, loading | `AppButton.outline` |
| TextLink | default, pressed, disabled | `AppTextLink` |
| PhoneField | kosong, fokus, terisi, error, disabled | `PhoneField` |
| OtpField | 6 kotak: kosong, fokus, terisi, error, disabled | `OtpField` |
| SearchBar | default, fokus, terisi + tombol hapus | `AppSearchBar` |
| EyebrowLabel | huruf kapital kecil | `EyebrowLabel` |
| TermsText | teks dengan dua tautan | `TermsText` |
| IllustrationCard | tema biru, tosca, ungu | `IllustrationCard` |
| LocationSelector | terpilih, belum ada alamat, loading | `LocationSelector` |
| NotificationBell | tanpa titik, dengan titik merah | `NotificationBell` |
| PromoBanner | gradien biru; 1–5 slide; loading | `PromoBanner` |
| ServiceCard | 6 warna pastel; default, pressed, nonaktif | `ServiceCard` |
| StatusChip | 10 status, masing-masing warna dan titik | `StatusChip` |
| StageProgress | tahap 1, 2, 3 dengan label | `StageProgress` |
| ActiveOrderCard | tahap 1–3; loading | `ActiveOrderCard` |
| HeroImageHeader | gambar + kembali + badge; tanpa badge; gambar gagal | `HeroImageHeader` |
| RatingPill | bintang + nilai; belum ada ulasan | `RatingPill` |
| InfoStatBox | dua kolom dengan pemisah | `InfoStatBox` |
| BenefitTile | ikon + label, grid 2 kolom | `BenefitTile` |
| NoteCallout | warning, info, error | `NoteCallout` |

Semua komponen: area sentuh ≥ 48 dp, kontras WCAG AA, tetap rapi pada ukuran teks sistem 130%.

### 3.3 Status desain layar

| Layar | Status di Figma |
| --- | --- |
| Splash, Onboarding slide 1–2, Login, OTP, Home, Detail Layanan | Selesai (7 layar) |
| Onboarding slide 3 | Belum |
| Form Pesanan, Daftar Alamat, Tambah Alamat, Ringkasan, Pembayaran, QRIS, Berhasil | Belum |
| Tracking, Riwayat, Detail Pesanan, Rating | Belum |
| Promo, Notifikasi, Profil, Ubah Profil, Pengaturan, layar state | Belum |
| Kurir (5 layar), Kasir (5 layar) | Belum |

Audit desain yang harus dibereskan di Figma sebelum dikodekan (agen: jangan "memperbaiki" ini di kode dengan akal-akalan):
1. Header tertutup Dynamic Island → tambah safe area 54 px.
2. Warna tombol "Selanjutnya" slide 2 berbeda → satu warna Primary.
3. OTP: "Kirim ulang" harus disabled selama timer berjalan.
4. Hapus tiga titik dekoratif di IllustrationCard.
5. Ganti foto stok hero layanan dengan foto/ilustrasi sendiri sebelum rilis.
6. Format harga: ringkas `Rp7rb` hanya untuk kartu kecil; penuh `Rp7.000` di tempat lain.
7. Pemetaan 10 status ke 3 tahap (bagian 5).
8. Padding bawah konten setinggi BottomNav.
9. Semua teks minimal 12 px.

---

## 4. Kebutuhan Fungsional

### Customer
| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| C-01 | Login dengan OTP nomor telepon (+62) atau Google | P0 |
| C-02 | Daftar layanan dan harga: Kiloan, Satuan, Express, Sepatu, Karpet, Selimut; Detail Layanan | P0 |
| C-03 | Buat pesanan: layanan, metode (Jemput Kurir / Antar Sendiri), alamat, tanggal dan slot jam, catatan, preferensi (pewangi, lipat atau gantung) | P0 |
| C-04 | Estimasi harga otomatis; harga final mengikuti timbangan kasir | P0 |
| C-05 | Pembayaran: QRIS, e-wallet, transfer bank, tunai | P0 |
| C-06 | Tracking status dengan timeline dan peta posisi kurir | P0 |
| C-07 | Notifikasi push tiap status berubah | P0 |
| C-08 | Riwayat, detail pesanan, Pesan Lagi | P0 |
| C-09 | Kelola alamat tersimpan (peta dengan pin) | P0 |
| C-10 | Batalkan pesanan selama status belum Dijemput | P0 |
| C-11 | Rating dan ulasan setelah Selesai | P1 |
| C-12 | Voucher promo | P1 |
| C-13 | Poin loyalitas, referral, chat, dark mode | P2 |
| C-14 | Layar Lengkapi Profil (nama) setelah OTP untuk akun baru | P0 |
| C-15 | Daftar Layanan lengkap dan pencarian layanan | P1 |
| C-16 | Alamat utama tampil di header Home dan bisa diganti | P0 |
| C-17 | Pesanan minimum per layanan (contoh Cuci Kiloan 3 kg) | P0 |
| C-18 | Promo pengguna baru (diskon cucian pertama, sekali pakai) | P1 |
| C-19 | Rating rata-rata dan badge ("Paling populer") per layanan | P1 |

### Kurir
| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| K-01 | Daftar tugas jemput dan antar, urut jam | P0 |
| K-02 | Detail tugas: alamat, kontak, catatan, tombol Navigasi (Google Maps) dan Hubungi | P0 |
| K-03 | Konfirmasi jemput dengan 1–4 foto kondisi pakaian dan catatan | P0 |
| K-04 | Konfirmasi antar dengan foto bukti; order tunai: catat uang diterima | P0 |
| K-05 | Bagikan lokasi real-time ke customer saat tugas berjalan | P1 |
| K-06 | Rekap pendapatan harian dan mingguan | P2 |

### Kasir
| ID | Kebutuhan | Prioritas |
| --- | --- | --- |
| S-01 | Daftar order masuk dengan filter status | P0 |
| S-02 | Input berat (kg) atau jumlah item; harga final otomatis | P0 |
| S-03 | Update status: Dicuci, Disetrika, Siap Diantar | P0 |
| S-04 | Tugaskan kurir ke order | P0 |
| S-05 | Nota digital dengan QR order | P0 |
| S-06 | Catat pembayaran tunai | P0 |
| S-07 | Scan QR order | P1 |
| S-08 | Cetak nota Bluetooth | P2 |

### Admin (P2)
A-01 kelola layanan, harga, slot; A-02 kelola akun kurir dan kasir; A-03 dashboard omzet dan ekspor laporan; A-04 promo dan komplain.

### Spesifikasi layar yang sudah didesain

| Layar | Komponen | Perilaku | Tujuan |
| --- | --- | --- | --- |
| Splash | BrandMark besar, judul, tagline "Cucian bersih, hidup tenang" | Maks 2 detik; cek sesi dan role | Belum pernah buka: Onboarding. Sudah login: Home sesuai role. Selain itu: Login |
| Onboarding (3 slide: "Pesan dari rumah", "Dijemput & diantar", "Pantau real-time") | AppBar (logo + Lewati), IllustrationCard, PageIndicator, Button/Primary | Geser atau "Selanjutnya"; slide terakhir "Mulai"; simpan penanda selesai di perangkat | Login |
| Login | AppBar (kembali + logo), EyebrowLabel "SELAMAT DATANG", PhoneField, "Kirim OTP", "atau", Google, TermsText | Validasi +62 dan 9–13 digit; loading; error jika gagal atau terlalu sering | OTP, atau Home bila Google berhasil |
| OTP | AppBar, ikon, judul "Verifikasi nomor kamu", nomor tersamar, OtpField, TextLink "Kirim ulang", "Verifikasi" | Auto-submit di 6 digit; timer kirim ulang 60 detik; error kode salah; batas percobaan | Home; atau Lengkapi Profil bila akun baru |
| Home | Header (sapaan, LocationSelector, NotificationBell), SearchBar, PromoBanner, SectionHeader, ServiceCard grid 3×2, ActiveOrderCard, BottomNav | Muat profil, alamat utama, promo, layanan, pesanan aktif; tarik untuk segarkan; cari menyaring layanan lokal | Layanan: Detail. Lokasi: Daftar Alamat. Lonceng: Notifikasi. Kartu pesanan: Tracking |
| Detail Layanan | HeroImageHeader, EyebrowLabel, RatingPill, InfoStatBox, BenefitTile ×4, NoteCallout, StickyActionBar | Data dari layanan; gambar gagal tampil placeholder | "Pesan Sekarang": Form Pesanan dengan layanan terpilih |

**State wajib di setiap layar:** loading (skeleton), error dengan "Coba Lagi", tanpa internet.
Home tambahan: tanpa pesanan aktif (kartu disembunyikan), belum ada alamat (LocationSelector mengajak menambah).

---

## 5. Alur Status Pesanan

Urutan (tidak boleh mundur atau melompat kecuali Dibatalkan):
Menunggu Konfirmasi → Kurir Menuju Lokasi → Dijemput → Ditimbang → Dicuci → Disetrika → Siap Diantar → Dalam Pengantaran → Selesai.
Pesanan **antar sendiri** melewati Kurir Menuju Lokasi, Dijemput, dan Dalam Pengantaran; Siap Diantar menjadi Siap Diambil.

| Dari | Ke | Oleh | Syarat |
| --- | --- | --- | --- |
| Menunggu Konfirmasi | Kurir Menuju Lokasi | Kasir | Kurir sudah ditugaskan |
| Kurir Menuju Lokasi | Dijemput | Kurir | Foto kondisi pakaian terunggah |
| Dijemput | Ditimbang | Kasir | Berat atau jumlah item terisi |
| Ditimbang | Dicuci | Kasir | Harga final tersimpan |
| Dicuci | Disetrika | Kasir | – |
| Disetrika | Siap Diantar | Kasir | – |
| Siap Diantar | Dalam Pengantaran | Kurir | Pembayaran lunas atau metode tunai |
| Dalam Pengantaran | Selesai | Kurir | Foto bukti terunggah |
| Menunggu Konfirmasi s.d. Kurir Menuju Lokasi | Dibatalkan | Customer atau Kasir | Belum berstatus Dijemput |

Setiap perubahan status mencatat waktu dan pelaku (`statusHistory`) dan memicu notifikasi push.

**Pemetaan ke StageProgress (3 tahap).** Label tengah menampilkan status sebenarnya (contoh "Sedang dicuci").

| Tahap | Label | Status |
| --- | --- | --- |
| 1 | Dijemput | Menunggu Konfirmasi, Kurir Menuju Lokasi, Dijemput |
| 2 | Diproses | Ditimbang, Dicuci, Disetrika, Siap Diantar |
| 3 | Diantar | Dalam Pengantaran, Selesai |

Dibatalkan tidak memakai StageProgress; tampil sebagai StatusChip merah.

---

## 6. Aturan Bisnis

- Kiloan: berat final (kg) × harga per kg. Satuan: jumlah × harga per item. Express: biaya tambahan persentase (angka dari pemilik).
- Pesanan minimum per layanan (`minQty`), contoh Cuci Kiloan 3 kg.
- Biaya antar-jemput mengikuti zona; gratis di atas nominal tertentu (angka dari pemilik).
- Estimasi bisa berbeda dari harga final; customer melihat harga final sebelum pengantaran.
- Pembayaran non-tunai harus lunas sebelum Dalam Pengantaran.
- Format uang: penuh `Rp7.000`, ringkas `Rp7rb`; satu fungsi `formatRupiah(int amount, {bool compact = false})`.
- Promo pengguna baru: hanya untuk pesanan pertama, satu kali, dengan potongan maksimum yang ditetapkan pemilik.

---

## 7. Kebutuhan Non-Fungsional

**Kualitas ("sebisa mungkin bebas bug")** — tidak ada jaminan 100%, tetapi standar berikut wajib:
- `flutter analyze` tanpa warning; `flutter_lints` aktif; null safety penuh.
- Setiap layar punya state loading, kosong, error, dan tanpa internet; input pengguna tidak hilang saat aksi gagal.
- Validasi input di aplikasi **dan** di server. Aksi buat pesanan dan bayar bersifat idempotent dan kebal klik ganda.
- Logika harga dan transisi status adalah fungsi murni di lapis domain, dites 100%.

**Keamanan**
- Firestore Security Rules membatasi akses per role dan per pemilik data; diuji otomatis (emulator).
- Tidak ada server key payment gateway di aplikasi; transaksi dibuat lewat Cloud Functions.
- Foto dan data pribadi hanya bisa diakses pihak terkait order.

**Performa dan kompatibilitas**
- Layar utama muncul < 2 detik di Android menengah dengan 4G.
- Android 8.0+, lebar layar 360–430 dp.

**Pemantauan:** Crashlytics aktif; beta internal 5–10 orang sebelum rilis.

---

## 8. Arsitektur dan Data

| Kebutuhan | Pilihan |
| --- | --- |
| Framework | Flutter stable, Dart null safety |
| State | Riverpod |
| Navigasi | `go_router` dengan redirect guard per role |
| Backend | Firebase: Auth, Firestore, Storage, Cloud Messaging, Crashlytics, Cloud Functions |
| Peta | `google_maps_flutter`, `geolocator` |
| Pembayaran | Midtrans atau Xendit (sandbox dulu) lewat Cloud Functions |
| Jaringan | `dio` |
| Tes | `flutter_test`, `mocktail`, `integration_test`, golden tests |
| CI | GitHub Actions: analyze + test |

```
lib/
  core/        theme/ widgets/ utils/ router/ errors/
  features/
    auth/ order/ tracking/ payment/ courier/ cashier/ profile/
      data/ domain/ presentation/
  main.dart
```

**Koleksi data**
- `users`: uid, nama, nomor HP, role, fcmToken
- `addresses`: userId, label, alamat, lat, lng, isPrimary
- `services`: label, name, description, startingPrice, unit, etaText, badge, ratingAvg, ratingCount, benefits[], minQty, note, imageUrl, tint, icon, isActive, sortOrder
- `orders`: customerId, kurirId, serviceId, metode, jadwal, status, berat, total, statusHistory[]
- `order_items`: orderId, nama, jumlah, harga
- `payments`: orderId, metode, nominal, status, referensi gateway
- `promos`: kode, judul, subjudul, label, potongan, masa berlaku, kuota, target
- `reviews`: orderId, rating, komentar
- `notifications`: userId, judul, isi, dibaca

---

## 9. Milestone dan Kriteria Selesai

Kerjakan berurutan. Berhenti di akhir tiap milestone dan laporkan: file yang berubah, perintah untuk menjalankan, daftar uji manual.

| M | Isi | Gate (harus terpenuhi) |
| --- | --- | --- |
| M1 | Fondasi proyek + tema + pustaka komponen + Component Gallery + golden test | `flutter analyze` bersih; gallery cocok dengan Figma; tes lulus |
| M2 | 6 layar yang sudah didesain dengan data tiruan (repository fake) | Alur Splash → Onboarding → Login → OTP → Home → Detail Layanan lulus integration test |
| M3 | Firebase Auth + role + Security Rules (C-01, C-14) | Uji akses lintas role ditolak sebagaimana mestinya |
| M4 | Pesan layanan (C-02 s.d. C-04, C-09, C-10, C-16, C-17) | Order tersimpan benar; harga sesuai aturan |
| M5 | Tracking, riwayat, notifikasi (C-06 s.d. C-08) | Status real-time berubah di customer |
| M6 | Alur Kasir (S-01 s.d. S-06) | Satu order berjalan sampai Siap Diantar |
| M7 | Alur Kurir (K-01 s.d. K-04) | Satu order berjalan sampai Selesai dengan foto |
| M8 | Pembayaran sandbox (C-05) | QRIS sandbox dan tunai berhasil |
| M9 | P1, polesan, aksesibilitas, uji penerimaan | Semua kriteria di bawah terpenuhi |

**Kriteria penerimaan MVP**
- [ ] Semua requirement P0 berfungsi.
- [ ] `flutter analyze` tanpa warning; semua tes lulus di CI.
- [ ] 50 order uji selesai tanpa order hilang atau status salah.
- [ ] Crash-free sessions > 99,5% pada beta.
- [ ] Security Rules lolos uji lintas role.
- [ ] Header tidak tertutup status bar/Dynamic Island; rapi pada teks 130% dan lebar 360 dp.

---

## 10. Keputusan Terbuka

- Biaya OTP SMS Firebase di luar kuota gratis: cek dokumentasi resmi sebelum rilis. Saat pengembangan pakai nomor uji; Google Sign-In menjadi jalur cadangan.
- Besaran potongan maksimum promo pengguna baru, biaya Express, biaya antar-jemput: diisi pemilik usaha.
- Foto hero layanan: foto sendiri atau ilustrasi.
- Tautan file Figma (`FIGMA_FILE_URL`) perlu diisi.
