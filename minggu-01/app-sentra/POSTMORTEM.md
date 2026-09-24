# POSTMORTEM

## Ringkasan

Praktikum DevOps dilakukan dengan fokus pada otomasi deployment aplikasi,
pengelolaan filesystem dan permission Linux, analisis log, monitoring
resource dan process, serta pembuatan script Bash yang modular.

## Yang Berjalan Baik

- Environment Python berhasil disiapkan menggunakan virtual environment.
- Dependensi aplikasi berhasil dipasang dari `requirements.txt`.
- `setup.sh` berhasil direfactor menjadi script modular.
- Fungsi umum dipisahkan ke `lib/common.sh`.
- Logging deployment menggunakan timestamp.
- Smoke test `/health` berhasil digunakan untuk memverifikasi aplikasi.
- Permission file berhasil dipraktikkan menggunakan `chmod`.
- Log sintetis berhasil dibuat dan dianalisis menggunakan pipeline Linux.
- `sysreport.sh` mendukung format text dan JSON serta threshold monitoring.
- ShellCheck digunakan untuk melakukan pemeriksaan kualitas script Bash.

## Kendala

### 1. Permission pada filesystem Windows-mounted

Percobaan permission dilakukan pada filesystem `/mnt/d`, tetapi permission
Linux tidak memberikan hasil yang diharapkan seperti pada filesystem Linux
native.

**Tindakan:** pekerjaan permission dipindahkan ke filesystem Linux di
`~/praktikum-devops`.

### 2. ShellCheck belum tersedia

Saat pertama kali menjalankan pemeriksaan, `shellcheck` belum terpasang.

**Tindakan:** ShellCheck dipasang menggunakan package manager Linux kemudian
script diperiksa kembali.

### 3. Struktur requirements aplikasi

File `requirements.txt` berada di dalam direktori `src`, sehingga path pada
`setup.sh` perlu disesuaikan menjadi:

`src/requirements.txt`

## Perbaikan

- Menggunakan filesystem Linux native untuk latihan permission.
- Memasang ShellCheck untuk validasi Bash script.
- Menggunakan fungsi modular pada `setup.sh`.
- Memisahkan fungsi umum ke `lib/common.sh`.
- Menambahkan `.gitignore` agar virtual environment, log, file kredensial
  latihan, dan file backup tidak ikut masuk repository.

## Pembelajaran

Praktikum menunjukkan bahwa otomasi deployment tidak hanya berkaitan dengan
menjalankan aplikasi, tetapi juga mencakup validasi environment, dependency
management, health check, logging, monitoring, permission, dan pemeriksaan
kualitas script.

## Tindak Lanjut

- Menjaga script deployment tetap modular dan mudah dipelihara.
- Menjalankan ShellCheck sebelum melakukan commit.
- Memastikan file sensitif dan artefak runtime tidak masuk repository.
- Melakukan verifikasi `git status` sebelum push.
