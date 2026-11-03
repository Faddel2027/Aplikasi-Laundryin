# Laundryin: Paket Proyek untuk Google Antigravity

Isi paket ini:

```
laundryin-antigravity/
├── AGENTS.md                      aturan permanen untuk agen (dibaca Antigravity di root proyek)
├── mcp_config.json                konfigurasi MCP: Figma, Dart/Flutter, Firebase
├── docs/PRD.md                    PRD lengkap (v1 + v2 digabung, ber-ID requirement)
└── .agent/workflows/
    ├── m1-design-system.md        /m1-design-system  → fondasi, tema, 27 komponen
    ├── build-screen.md            /build-screen      → bangun satu layar dari frame Figma
    ├── verify.md                  /verify            → analyze + test + laporan jujur
    └── security-rules.md          /security-rules    → aturan keamanan Firestore + tes
```

## Langkah 1: Siapkan alat

1. Pasang **Flutter SDK** (versi stabil terbaru) dan jalankan `flutter doctor` sampai bersih.
2. Pasang **Node.js** (dibutuhkan untuk server Firebase MCP dan proses login OAuth beberapa MCP).
3. Pasang **Google Antigravity** dan masuk dengan akun Google.
4. Untuk Firebase: pasang `firebase-tools` dan jalankan `firebase login` (belum perlu membuat project).

## Langkah 2: Buat folder proyek

1. Buat folder kosong `laundryin` lalu salin seluruh isi paket ini ke dalamnya (termasuk folder tersembunyi `.agent`).
2. Buka folder itu di Antigravity (**File → Open Folder**).
3. Buka `docs/PRD.md`, cari `FIGMA_FILE_URL`, ganti dengan tautan file Figma Anda.

## Langkah 3: Pasang MCP

1. Di panel Agent, klik menu **⋯ → MCP Servers → Manage MCP Servers → View raw config**.
   Ini membuka file `mcp_config.json` milik Antigravity (biasanya di `~/.gemini/antigravity/mcp_config.json`).
2. Salin isi `mcp_config.json` dari paket ini ke dalamnya (gabungkan dengan server lain yang sudah ada), simpan, lalu muat ulang panel MCP.
3. Saat pertama memakai Figma, agen akan meminta Anda login ke Figma di browser. Izinkan akses.

Catatan penting:
- Antigravity memakai kunci `serverUrl` (bukan `url`) untuk server MCP jarak jauh.
- Nama server jangan memakai spasi (`figma`, bukan `Figma Desktop`).
- Jika server Figma jarak jauh gagal, alternatifnya memakai Figma Desktop: buka file di aplikasi desktop, aktifkan server MCP di Dev Mode, lalu ganti isi server `figma` menjadi `"serverUrl": "http://127.0.0.1:3845/mcp"`.
- Jika muncul galat OAuth, pastikan Node.js terpasang, mulai ulang komputer, lalu pasang ulang server MCP.
- Dart MCP membutuhkan Dart/Flutter SDK versi yang cukup baru; cek dengan `dart mcp-server --help`.
- Ketersediaan dan batas pemakaian MCP Figma di paket gratis dapat berubah; cek di situs Figma.

## Langkah 4: Jalankan milestone pertama

Di panel Agent, ketik `/m1-design-system` lalu kirim. Agen akan:
membaca PRD dan Figma, membuat fondasi proyek Flutter, tema, 27 komponen, Component Gallery, dan tes,
lalu berhenti dan melaporkan hasilnya.

Anda lalu menjalankan di perangkat:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Bandingkan Component Gallery dengan Figma, laporkan temuan ke agen, dan baru lanjut ke milestone berikutnya.

## Langkah 5: Lanjutkan per milestone

Urutan ada di `docs/PRD.md` bagian 9 (M2 sampai M9). Untuk tiap layar:

```
/build-screen
Frame: <tempel tautan frame Figma>
Layar: Home
```

Selalu akhiri dengan `/verify`. Untuk keamanan data, jalankan `/security-rules` sebelum menghubungkan data asli.

## Prompt pembuka cadangan (jika ingin tanpa workflow)

```text
Read AGENTS.md and docs/PRD.md. Use the figma MCP server to read the Laundryin Figma file.
Start milestone M1 only: project foundation, theme from Figma variables, all 27 core widgets,
Component Gallery, unit/widget/golden tests. Run flutter analyze and flutter test, then stop and report.
```

## Soal "tanpa bug"

Tidak ada pengembang atau AI yang bisa menjamin nol bug. Paket ini menekan risikonya dengan aturan di `AGENTS.md`:
nol warning analyze, tes berlapis, semua state layar wajib ada, Security Rules yang dites, dan laporan yang jujur
(agen dilarang mengklaim tes lulus jika tidak menjalankannya). Tetap uji di perangkat nyata setelah tiap milestone
dan beta test ke beberapa orang sebelum rilis.

## Yang perlu Anda isi sendiri

- Tautan file Figma (`FIGMA_FILE_URL` di `docs/PRD.md`).
- Angka bisnis: potongan maksimum promo, biaya Express, biaya antar-jemput, harga per layanan.
- Akun Firebase dan akun sandbox Midtrans/Xendit saat milestone M3 dan M8.
- Foto layanan milik sendiri (pengganti foto stok).
