# go-setup

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash-4EAA25.svg)](setup-go.sh)
[![tests](https://github.com/8b-is/go-setup/actions/workflows/ci.yml/badge.svg)](https://github.com/8b-is/go-setup/actions)

One-shot, idempotent **Go toolchain setup** for the 8b-is constellation,
targeted at Apple Silicon Macs (M1 / M1 64GB).

## One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/8b-is/go-setup/main/setup-go.sh | bash
```

To inspect the detected Apple Silicon unified-memory profile (`GOMEMLIMIT`, `GOGC`, `GOARCH=arm64`, `CGO_ENABLED=1`) and `1b-go -> b8-go` alias without modifying dotfiles or installing packages:

```bash
./setup-go.sh --check
```

## What it does

1. Installs **Homebrew** (if missing) and wires `/opt/homebrew` into `PATH`.
2. Installs **Go** via `brew install go`.
3. Lays out `GOPATH=~/go`, `GOBIN=~/go/bin`, `GOPROXY=proxy.golang.org,direct` and
   persists them into `~/.zprofile`.
4. Tunes Apple Silicon unified memory per node — `GOARCH=arm64`, `CGO_ENABLED=1`,
   `GOGC=100`, and `GOMEMLIMIT` sized to `hw.memsize` (50 GiB / 20 GiB / 10 GiB
   for the 64GB / 32GB / 16GB nodes).
5. Symlinks `1b-go -> b8-go` (the 1-bit / balanced ternary alias) into `$GOBIN`.
6. Installs the repos' expected tooling: `golangci-lint`, `staticcheck`, `gofumpt`, `air`.
7. Verifies `go version` and the environment.

Safe to re-run; every step is a no-op when already satisfied.

## Homebrew

```bash
brew tap 8b-is/go-setup
brew install --HEAD b8-go    # also installs the 1b-go alias
```

The formula lives in [`Formula/b8-go.rb`](Formula/b8-go.rb).

## Languages (Zig · Idris · Perl)

Companion script for the other sovereign languages — idempotent, cross-platform
(macOS via Homebrew, Linux via apt):

```bash
curl -fsSL https://raw.githubusercontent.com/8b-is/go-setup/main/setup-langs.sh | bash
```

Installs and verifies `zig`, `idris2`, and `perl`.

## License

MIT — from love, from within.
