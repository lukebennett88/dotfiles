#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

[[ $# -gt 0 ]] || { echo "usage: ${0##*/} <stow-package>..." >&2; exit 2; }

export HOMEBREW_NO_AUTO_UPDATE=1
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
echo '==> bash -n'
for f in setup.sh scripts/*.sh; do bash -n "$f"; done
echo '==> shellcheck'
shellcheck setup.sh scripts/*.sh
echo '==> zsh -n'
git ls-files -z -- zsh | xargs -0 -n1 zsh -n
echo '==> git config'
git config --file git/.gitconfig --list >/dev/null
git config --file git/.gitconfig-personal --list >/dev/null
echo '==> brew bundle list'
cat Brewfile optional/Brewfile > "$tmp/Brewfile"
brew bundle list --file "$tmp/Brewfile" --all >/dev/null
echo '==> skills manifest'
./scripts/skills.sh validate
echo '==> stow dry run'
mkdir "$tmp/home"
stow --target="$tmp/home" --restow "$@"
find "$tmp/home" -type l -print0 > "$tmp/links"
while IFS= read -r -d '' link; do
	source=$(realpath "$link")
	if ! git ls-files --error-unmatch -- "$source" >/dev/null 2>&1; then
		printf 'stow would link untracked file: %s\n' "$source" >&2
		exit 1
	fi
done < "$tmp/links"
echo 'All checks passed.'
