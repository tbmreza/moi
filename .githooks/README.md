# Git hooks

Secret-scanning hooks. No external dependencies (bash + git only).

- `pre-commit` — blocks commits that add likely secrets to staged files.
- `pre-push` — blocks pushes that introduce likely secrets (history backstop).
- `lib.secrets.sh` — shared patterns, sourced by both hooks.

## One-time setup (per machine)

```sh
git config core.hooksPath .githooks
```

## Tuning

Patterns live in `lib.secrets.sh`:

- `SECRET_HIGH` — private keys and common cloud/API token formats.
- `SECRET_ASSIGN` — `password`/`secret`/`token`/`api_key` = `<literal>` lines.
- `SECRET_PLACEHOLDER` — placeholder values to ignore (avoid false positives).

Bypass a false positive with `git commit --no-verify` or `git push --no-verify`.
