#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$APP_DIR/.venv"
PORT="${PORT:-5000}"

# shellcheck source=lib/common.sh
source "$APP_DIR/lib/common.sh"

check_python() {
    require_cmd python3

    python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3,10) else 1)' ||
        die "dibutuhkan Python 3.10 atau lebih baru."
}

setup_venv() {
    if [[ ! -d "$VENV_DIR" ]]; then
        log_info "Membuat virtual environment..."
        python3 -m venv "$VENV_DIR"
    else
        log_info "Virtual environment sudah tersedia."
    fi

    # shellcheck disable=SC1091
    source "$VENV_DIR/bin/activate"
}

install_dependencies() {
    log_info "Memasang dependensi terkunci..."
    pip install --quiet --upgrade pip
    pip install --quiet -r "$APP_DIR/src/requirements.txt"
}

start_app() {
    log_info "Menjalankan aplikasi pada port $PORT..."

    PORT="$PORT" python3 "$APP_DIR/src/app.py" &
    APP_PID=$!

    trap 'kill "$APP_PID" 2>/dev/null || true' EXIT
}

smoke_test() {
    log_info "Melakukan smoke test..."

    if curl -fsS "http://127.0.0.1:$PORT/health" >/dev/null; then
        log_info "Aplikasi berjalan dan lulus health check (PID $APP_PID)."
    else
        die "Aplikasi tidak merespons health check."
    fi
}

main() {
    log_info "Memeriksa prasyarat..."
    check_python

    log_info "Menyiapkan virtual environment..."
    setup_venv

    install_dependencies
    start_app

    sleep 3
    smoke_test

    log_info "Tekan Ctrl+C untuk menghentikan aplikasi."

    wait "$APP_PID"
}

main "$@"
