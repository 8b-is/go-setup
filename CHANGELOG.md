# Changelog

All notable changes to `go-setup` are documented here, following
[Keep a Changelog](https://keepachangelog.com/) and
[Semantic Versioning](https://semver.org/).

## [0.1.0] — 2026-10-27

### Added
- `setup-go.sh` — idempotent Apple-Silicon Go toolchain setup (Homebrew → Go →
  `GOPATH/GOBIN/GOPROXY` → tooling → verify).
- `Formula/b8-go.rb` — tap-ready Homebrew formula with the `1b-go` alias.
- Apple Silicon unified-memory tuning — `GOARCH=arm64`, `CGO_ENABLED=1`,
  `GOGC=100`, and `GOMEMLIMIT` sized from `hw.memsize` (50/20/10 GiB for
  64/32/16 GB nodes).
- One-liner installer and `brew install --HEAD b8-go` path.
