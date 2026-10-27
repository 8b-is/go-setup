# go-setup

One-shot, idempotent **Go toolchain setup** for the 8b-is constellation,
targeted at Apple Silicon Macs (M1 / M1 64GB).

## One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/8b-is/go-setup/main/setup-go.sh | bash
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

## License

MIT — from love, from within.
