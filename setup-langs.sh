#!/usr/bin/env bash
#
# 8b-is language setup — Zig, Idris 2, Perl. Idempotent, cross-platform:
# macOS via Homebrew, Linux via apt. Safe to re-run.
#
#   curl -fsSL https://raw.githubusercontent.com/8b-is/go-setup/main/setup-langs.sh | bash

set -euo pipefail

log()  { printf '\033[1;36m[8b-langs]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[ok]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }

OS="$(uname -s)"

# --- package manager -----------------------------------------------------
install_pkg() {
    case "$OS" in
        Darwin)
            if ! command -v brew >/dev/null 2>&1; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
            fi
            brew install "$@"
            ;;
        Linux)
            if command -v apt-get >/dev/null 2>&1; then
                apt-get update -y
                apt-get install -y "$@"
            else
                warn "no apt-get; install zig/idris2/perl manually"
                return 1
            fi
            ;;
        *)
            warn "unsupported OS: $OS"
            return 1
            ;;
    esac
}

# --- 1. Zig --------------------------------------------------------------
if command -v zig >/dev/null 2>&1; then
    ok "zig present ($(zig version))"
else
    log "installing zig…"
    install_pkg zig
fi

# --- 2. Idris 2 ----------------------------------------------------------
if command -v idris2 >/dev/null 2>&1; then
    ok "idris2 present ($(idris2 --version 2>/dev/null | head -1))"
else
    log "installing idris2…"
    install_pkg idris2
fi

# --- 3. Perl -------------------------------------------------------------
if command -v perl >/dev/null 2>&1; then
    ok "perl present (v$(perl -e 'print $^V' 2>/dev/null))"
else
    log "installing perl…"
    install_pkg perl
fi

# --- 4. verify -----------------------------------------------------------
log "verifying…"
zig version
idris2 --version 2>/dev/null | head -1
perl -e 'print "perl ", $^V, "\n"'

log "done. zig + idris2 + perl ready. om mani padme hung."
