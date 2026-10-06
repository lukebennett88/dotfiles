#!/usr/bin/env bash
set -euo pipefail

cli="skills@1.7.0"
manifest="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/skills.txt"

each_manifest_entry() {
	local entry
	while read -r -a entry || [[ ${#entry[@]} -gt 0 ]]; do
		[[ ${#entry[@]} -eq 0 || ${entry[0]} == \#* ]] && continue
		[[ ${#entry[@]} -ge 2 ]] || { echo "skills.txt: '${entry[0]}' lists no skills" >&2; exit 1; }
		"$@" "${entry[@]}"
	done < "$manifest"
}

install_entry() {
	local source="$1"
	shift
	mise exec -- pnpm dlx "$cli" add "$source" --skill "$@" --global --agent universal claude-code --yes
}

# Manifest callback: drop the source, print skill names.
listed_skills() {
	shift
	printf '%s\n' "$@"
}

check() (
	local agents_dir="$HOME/.agents/skills" claude_dir="$HOME/.claude/skills"
	local d link target resolved agents_root=''
	local dangling=() external=()
	local tmp
	tmp="$(mktemp -d)"
	trap 'rm -rf "$tmp"' EXIT
	if [[ -d $agents_dir ]]; then
		agents_root="$(/bin/realpath -q "$agents_dir")" || { echo "Could not resolve $agents_dir" >&2; return 1; }
	fi

	each_manifest_entry listed_skills | sort -u > "$tmp/listed"
	for d in "$agents_dir"/*/; do
		[[ -d $d ]] || continue
		basename "$d"
	done | sort -u > "$tmp/installed"

	for link in "$claude_dir"/*; do
		[[ -L $link ]] || continue
		target="$(readlink "$link")"
		if [[ ! -e $link ]]; then
			dangling+=("$(basename "$link") -> $target")
			continue
		fi
		resolved="$(/bin/realpath -q "$link")" || { echo "Could not resolve $link" >&2; return 1; }
		[[ -n $agents_root && ( $resolved == "$agents_root" || $resolved == "$agents_root"/* ) ]] || external+=("$(basename "$link") -> $target")
	done
	echo '==> Listed in skills.txt but not installed'
	comm -23 "$tmp/listed" "$tmp/installed"
	echo '==> Installed but not listed in skills.txt'
	comm -13 "$tmp/listed" "$tmp/installed"
	echo '==> Dangling links in ~/.claude/skills'
	[[ ${#dangling[@]} -eq 0 ]] || printf '%s\n' "${dangling[@]}"
	echo '==> External links in ~/.claude/skills (left alone)'
	[[ ${#external[@]} -eq 0 ]] || printf '%s\n' "${external[@]}"
)

case "${1:-}" in
	install) each_manifest_entry :; each_manifest_entry install_entry ;;
	validate) each_manifest_entry : ;;
	check) check ;;
	*) echo "usage: ${0##*/} install|validate|check" >&2; exit 2 ;;
esac
