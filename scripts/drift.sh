#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
brewfile="${1:-$root/Brewfile}"
optional_brewfile="${2:-$root/optional/Brewfile}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cat "$brewfile" "$optional_brewfile" > "$tmp/Brewfile"
export HOMEBREW_NO_AUTO_UPDATE=1
brew bundle list --file "$tmp/Brewfile" --all >/dev/null
echo '==> Installed but not in either Brewfile'
if brew bundle cleanup --file "$tmp/Brewfile" </dev/null >"$tmp/cleanup.out" 2>"$tmp/cleanup.err"; then
	status=0
else
	status=$?
fi
sed '/^Run .brew bundle cleanup/d' "$tmp/cleanup.out"
cat "$tmp/cleanup.err" >&2
if (( status == 1 )); then
	[[ ! -s "$tmp/cleanup.err" ]] || exit 1
	grep -Eq '^Would (uninstall .+|untap):$' "$tmp/cleanup.out" || exit 1
	[[ $(tail -n 1 "$tmp/cleanup.out") == "Run \`brew bundle cleanup --force\` to make these changes." ]] || exit 1
	if grep -Eq '^Error[: ]' "$tmp/cleanup.out"; then exit 1; fi
elif (( status != 0 )); then
	exit "$status"
fi
echo '==> In a Brewfile but not installed'
if brew bundle check --file "$tmp/Brewfile" --verbose </dev/null >"$tmp/check.out" 2>"$tmp/check.err"; then
	status=0
else
	status=$?
fi
cat "$tmp/check.out"
cat "$tmp/check.err" >&2
if (( status == 1 )); then
	[[ $(head -n 1 "$tmp/check.err") == "brew bundle can't satisfy your Brewfile's dependencies." ]] || exit 1
	[[ $(tail -n 1 "$tmp/check.err") == "Satisfy missing dependencies with \`brew bundle install\`." ]] || exit 1
	if grep -Eq '^Error[: ]' "$tmp/check.err"; then exit 1; fi
elif (( status != 0 )); then
	exit "$status"
fi
