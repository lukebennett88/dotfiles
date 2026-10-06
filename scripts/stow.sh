#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

[[ $# -gt 0 ]] || { echo "usage: ${0##*/} <stow-package>..." >&2; exit 2; }

tmp="$(mktemp -d)"
migrated_dest=()
migrated_target=()
migrated_source=()
cleanup() {
	local result=$? i dest
	trap - EXIT
	if (( result != 0 )); then
		for (( i=0; i<${#migrated_dest[@]}; i++ )); do
			dest=${migrated_dest[i]}
			if [[ -L $dest && $(readlink "$dest") == "${migrated_target[i]}" ]]; then continue; fi
			if [[ -L $dest && $(realpath "$dest") == "${migrated_source[i]}" ]]; then rm "$dest"; fi
			if [[ ! -e $dest && ! -L $dest ]]; then ln -s "${migrated_target[i]}" "$dest"; fi
		done
	fi
	rm -rf "$tmp"
	exit "$result"
}
trap cleanup EXIT
mkdir "$tmp/home"
stow --target="$tmp/home" --restow "$@"
find "$tmp/home" -type l -print0 > "$tmp/links"
while IFS= read -r -d '' link; do
	rel=${link#"$tmp/home/"}
	dest="$HOME/$rel"
	[[ -L $dest ]] || continue
	source=$(realpath "$link")
	target=$(readlink "$dest")
	[[ $target == /* && $(realpath "$dest") == "$source" ]] || continue
	migrated_dest+=("$dest")
	migrated_target+=("$target")
	migrated_source+=("$source")
	rm "$dest"
done < "$tmp/links"
stow --restow "$@"
