# Security Policy

`go-setup` installs a Go toolchain; it should never be a vector for compromise.

- The script is idempotent and only installs pinned, well-known tooling
  (`golangci-lint`, `staticcheck`, `gofumpt`, `air`) from their canonical module
  paths via `go install …@latest`.
- Homebrew is installed from the official `Homebrew/install` script only.
- No credentials are requested, stored, or logged. `GOPROXY` defaults to the
  official `proxy.golang.org`.

## Reporting a vulnerability

Email `security@8b.is` with the affected script/formula, a reproduction, and
the impact. Do not open a public issue. We respond within 72 hours.

## Supported versions

Only the latest `main` and the latest tagged release are supported.
