#!/usr/bin/env bash
#
# 8b-is Go e2e setup — idempotent, Apple Silicon (M1/M2/M3) focused.
#
#   curl -fsSL https://raw.githubusercontent.com/8b-is/go-setup/main/setup-go.sh | bash
#
# Installs (if missing), configures, and verifies a complete Go toolchain for
# the 8b-is constellation: Go itself, the standard GOPATH/GOPROXY/GOBIN layout,
# and the linters/build tools the repos expect. Safe to re-run.

set -euo pipefail

readonly GO_MIN="1.22"
readonly BREW_ARM="/opt/homebrew/bin/brew"
readonly BREW_X86="/usr/local/bin/brew"

log()  { printf '\033[1;36m[8b-go]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[ok]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }

# --- 1. Homebrew -------------------------------------------------------------
if command -v brew >/dev/null 2>&1; then
    ok "Homebrew already present ($(brew --version | head -1))"
elif [[ -x "$BREW_ARM" || -x "$BREW_X86" ]]; then
    eval "$("$BREW_ARM" shellenv 2>/dev/null || "$BREW_X86" shellenv)"
    ok "Homebrew found on disk; wired into PATH"
else
    log "Installing Homebrew…"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -x "$BREW_ARM" ]]; then
        eval "$("$BREW_ARM" shellenv)"
    else
        eval "$("$BREW_X86" shellenv)"
    fi
fi

# --- 2. Go toolchain ---------------------------------------------------------
if command -v go >/dev/null 2>&1; then
    ok "Go already present ($(go version))"
else
    log "Installing Go via Homebrew…"
    brew install go
fi

# --- 3. Environment layout ---------------------------------------------------
GOPATH_DEFAULT="$HOME/go"
GOBIN_DEFAULT="$GOPATH_DEFAULT/bin"

export GOPATH="${GOPATH:-$GOPATH_DEFAULT}"
export GOBIN="${GOBIN:-$GOBIN_DEFAULT}"
# Default module proxy; swap to a regional mirror if preferred.
export GOPROXY="${GOPROXY:-https://proxy.golang.org,direct}"
mkdir -p "$GOPATH" "$GOBIN"

# Persist into the shell profile when not already present, so a fresh login
# picks up the layout without manual export.
for VAR in GOPATH GOBIN GOPROXY; do
    if ! grep -q "export $VAR=" "$HOME/.zprofile" 2>/dev/null; then
        {
            echo ""
            echo "# 8b-is Go setup ($(date +%Y-%m-%d))"
            echo "export $VAR=${!VAR}"
        } >> "$HOME/.zprofile"
        warn "Appended $VAR to ~/.zprofile"
    fi
done

# --- 4. Tooling --------------------------------------------------------------
install_tool() {
    local name="$1" pkg="$2"
    if command -v "$name" >/dev/null 2>&1; then
        ok "$name already present"
    else
        log "Installing $name…"
        go install "$pkg@latest"
    fi
}

install_tool golangci-lint github.com/golangci/golangci-lint/cmd/golangci-lint
install_tool staticcheck   honnef.co/go/tools/cmd/staticcheck
install_tool gofumpt       mvdan.cc/gofumpt
install_tool air           github.com/air-verse/air

# --- 5. Verify ---------------------------------------------------------------
log "Verifying…"
go version
log "GOPATH  = $(go env GOPATH)"
log "GOBIN   = $(go env GOBIN)"
log "GOPROXY = $(go env GOPROXY)"

if [[ "${1:-}" == "--check" ]]; then
    ok "Check complete"
    exit 0
fi

cat <<'EOF'

8b-is Go toolchain is ready. Next:
  export PATH="$PATH:$(go env GOPATH)/bin"
  cd <repo> && go test ./...

From love, from within. om mani padme hung.
EOF
