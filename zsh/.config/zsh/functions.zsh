# Contains all user-defined functions

_confirm_yn() {
	local confirm
	read -r -k 1 "confirm?$1 " || {
		print ''
		print 'Operation cancelled.'
		return 1
	}
	print ''
	if [[ "$confirm" != [Yy] ]]; then
		print 'Operation cancelled.'
		return 1
	fi
}

_git_require_repo() {
	if ! git rev-parse --git-dir >/dev/null 2>&1; then
		print -u2 "$1"
		return 1
	fi
}

# Print local branch names safe to delete.
# $1 and $2 are branches to keep; remaining args go to git for-each-ref.
_git_deletable_branches() {
	local keep_one="$1" keep_two="$2"
	shift 2
	local refs_output ref branch worktree_path

	refs_output="$(git for-each-ref "$@" \
		--format='%(refname:lstrip=2)%09%(worktreepath)' \
		refs/heads/)" || return 1

	for ref in "${(@f)refs_output}"; do
		[[ -z "$ref" ]] && continue
		branch="${ref%%$'\t'*}"
		worktree_path="${ref#*$'\t'}"
		[[ "$branch" == "$keep_one" || "$branch" == "$keep_two" ]] && continue
		if [[ -n "$worktree_path" ]]; then
			print -u2 "Keeping checked-out branch: $branch"
			continue
		fi
		print -r -- "$branch"
	done
}

# Delete local branches except the kept and checked-out branches, after confirmation.
gbdm() {
	if (( $# > 1 )); then
		print -u2 'Usage: gbdm [branch-to-keep]'
		return 2
	fi
	_git_require_repo 'gbdm must run inside a Git repository.' || return 1

	local branches_output
	local -a branches
	branches_output="$(_git_deletable_branches "${1:-main}" '')" || return $?
	branches=(${(@f)branches_output})

	if (( ${#branches} == 0 )); then
		print 'No branches to delete.'
		return 0
	fi

	print 'Branches to force-delete (unmerged work included):'
	printf '  %s\n' "${branches[@]}"

	_confirm_yn "Delete these ${#branches} branches? [y/N]" || return 0

	git branch -D -- "${branches[@]}"
}

# Delete merged local branches except main/master and checked-out branches.
rmmerged() {
	_git_require_repo 'rmmerged must run inside a Git repository.' || return 1

	local result_code=0 names_output
	local -a names
	names_output="$(_git_deletable_branches main master --merged=HEAD)" || return $?
	names=(${(@f)names_output})

	if (( ${#names} )); then
		git branch -d -- "${names[@]}" || result_code=1
	fi

	if git remote get-url origin >/dev/null 2>&1; then
		git remote prune origin || result_code=1
	fi
	return $result_code
}

# Create a directory and change into it.
mkcd() {
	if (( $# != 1 )); then
		print -u2 'Usage: mkcd directory'
		return 2
	fi
	mkdir -p -- "$1" && cd -- "$1"
}

# Extract common archive formats.
extract() {
	if (( $# != 1 )); then
		print -u2 'Usage: extract archive'
		return 2
	fi

	local archive="$1"
	local -a extract_command
	local tool
	if [[ ! -f "$archive" ]]; then
		print -u2 "Not a regular file: $archive"
		return 1
	fi
	archive="${archive:a}"

	case "$archive" in
		*.tar|*.tar.*|*.tgz|*.tbz2|*.txz|*.tzst) extract_command=(tar -xf "$archive") ;;
		*.bz2) extract_command=(bunzip2 "$archive") ;;
		*.gz) extract_command=(gunzip "$archive") ;;
		*.rar) extract_command=(unrar e -- "$archive") ;;
		*.zip) extract_command=(unzip "$archive") ;;
		*.Z) extract_command=(uncompress "$archive") ;;
		*.7z) extract_command=(7z x "$archive") ;;
		*) print -u2 "Unsupported archive: $archive"; return 2 ;;
	esac

	tool="${extract_command[1]}"
	if ! command -v "$tool" >/dev/null 2>&1; then
		print -u2 "Cannot extract $archive: required command '$tool' is missing."
		return 127
	fi

	command "${extract_command[@]}"
}

# Preview ignored and untracked files, then confirm before deleting them.
git_clean_safe() {
	_git_require_repo 'git_clean_safe must run inside a Git repository.' || return 1

	print 'Files that would be deleted:'
	git clean -fxdn || return $?

	_confirm_yn 'Delete these files? [y/N]' || return 0

	git clean -fxd || {
		print -u2 'Git clean failed; some files may remain.'
		return 1
	}
	print 'Done.'
}
