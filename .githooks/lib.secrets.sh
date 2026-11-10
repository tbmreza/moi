# .githooks/lib.secrets.sh — shared secret-detection patterns and helpers.
# Sourced (not executed) by pre-commit and pre-push. bash + git only, no deps.

# High-confidence formats: private keys and common cloud/API token shapes.
SECRET_HIGH='-----BEGIN [A-Z ]*PRIVATE KEY-----|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|gh[opusr]_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{20,}|xox[baprs]-[0-9A-Za-z-]{10,}|sk_live_[0-9a-zA-Z]{24,}'

# "key = <literal>" assignments (password/secret/token/api_key/access_key).
# Value must be a non-empty literal of 6+ chars; quotes are optional.
SECRET_ASSIGN=$(cat <<'EOF'
(password|passwd|pass|secret|token|api[_-]?key|apikey|access[_-]?key)[[:space:]]*[:=][[:space:]]*["'`]?[A-Za-z0-9/+_.-]{6,}["'`]?
EOF
)

# Values that look like secrets but are placeholders — skip these to avoid
# false positives (e.g. "password=CHANGE_ME", "token=your-api-key").
SECRET_PLACEHOLDER='CHANGE_ME|CHANGEME|TODO|FIXME|example|EXAMPLE|your[-_]?|xxx+|redacted|REDACTED'

# secret_check <file>
#   Print any suspicious lines as "<file>:<line>:<text>".
#   Return 0 if a secret was found, 1 otherwise.
secret_check() {
  file="$1"
  # Ignore binary and empty files.
  grep -Iq . "$file" || return 1

  high=$(grep -HnE "$SECRET_HIGH" "$file" 2>/dev/null)
  assign=$(grep -HnE "$SECRET_ASSIGN" "$file" 2>/dev/null | grep -Ev "$SECRET_PLACEHOLDER")

  if [ -n "$high" ] || [ -n "$assign" ]; then
    [ -n "$high" ] && printf '%s\n' "$high"
    [ -n "$assign" ] && printf '%s\n' "$assign"
    return 0
  fi
  return 1
}
