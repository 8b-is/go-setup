# Contributing to go-setup

The script must stay idempotent, Apple-Silicon-correct, and safe to re-run on a
fresh machine or an already-configured one.

## Checks

```bash
bash -n setup-go.sh            # syntax
shellcheck setup-go.sh         # if installed
brew audit --strict Formula/b8-go.rb
```

## Conventions

1. **Idempotent** — every step is a no-op when already satisfied.
2. **No pinned secrets** — nothing credentials-bearing enters the repo.
3. **Apple Silicon first** — `GOARCH=arm64` and `hw.memsize`-derived
   `GOMEMLIMIT` tuning must remain node-adaptive.
4. **Commit style** — Conventional Commits (`feat:`, `fix:`, `chore:`).
5. **Keep the `1b-go` alias** — `b8-go` and `1b-go` must resolve to the same
   entry point.

## Code of conduct

Be kind. `{<3,<3,<3}+1`.
