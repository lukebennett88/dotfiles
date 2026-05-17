#!/bin/bash
set -euo pipefail

# Install required Homebrew entries from Brewfile, then offer an fzf
# multi-select picker for entries in Brewfile.optional.
#
# Usage:
#   install-brewfile.sh             # required + interactive picker
#   install-brewfile.sh --all       # required + all optional, no picker
#   install-brewfile.sh --none      # required only, skip picker

source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

DOTFILES="$(dotfiles_root)"
BREWFILE="$DOTFILES/Brewfile"
OPTIONAL="$DOTFILES/Brewfile.optional"

MODE="interactive"
for arg in "$@"; do
	case "$arg" in
		--all)  MODE="all" ;;
		--none) MODE="none" ;;
		*) error "Unknown flag: $arg"; exit 2 ;;
	esac
done

# -- 1. Install required Brewfile ---------------------------------------------

if [ ! -f "$BREWFILE" ]; then
	error "Brewfile not found at $BREWFILE"
	exit 1
fi

info "Installing required Brewfile..."
brew bundle --file="$BREWFILE"
success "Required Brewfile installed."

# -- 2. Optional picker -------------------------------------------------------

if [ ! -f "$OPTIONAL" ]; then
	info "No Brewfile.optional found. Skipping optional installs."
	exit 0
fi

# Trim leading and trailing whitespace. Pure bash — no subprocess, no echo
# (which would mangle inputs that happen to start with `-`).
trim() {
	local s="$1"
	s="${s#"${s%%[![:space:]]*}"}"
	s="${s%"${s##*[![:space:]]}"}"
	printf '%s' "$s"
}

# Convert one "type:value  # description" line to valid Brewfile syntax.
to_brewfile_line() {
	local line="$1"
	line="${line%%#*}"                          # strip trailing comment
	line="$(trim "$line")"
	[ -z "$line" ] && return

	local type="${line%%:*}"
	local rest="${line#*:}"

	if [ -z "$rest" ]; then
		warn "Empty value for entry: $line"
		return
	fi

	case "$type" in
		brew|cask|tap)
			printf '%s\n' "$type \"$rest\""
			;;
		mas)
			local name="${rest%=*}"
			local id="${rest##*=}"
			if [ -z "$name" ] || [ -z "$id" ] || [ "$name" = "$id" ]; then
				warn "Malformed mas entry (expected mas:Name=id): $line"
				return
			fi
			printf '%s\n' "mas \"$name\", id: $id"
			;;
		*)
			warn "Unknown entry type: $type ($line)"
			;;
	esac
}

entry_label() {
	local line="$1"
	local entry desc type rest
	entry="$(trim "${line%%#*}")"
	desc=""
	if [[ "$line" == *"#"* ]]; then
		desc="$(trim "${line#*#}")"
	fi
	type="${entry%%:*}"
	rest="${entry#*:}"

	if [ -n "$desc" ]; then
		printf '%-5s %-38s %s\n' "$type" "$rest" "$desc"
	else
		printf '%-5s %s\n' "$type" "$rest"
	fi
}

# Pull all selectable lines. Allow leading whitespace; strip it on parse.
ENTRIES="$(grep -E '^[[:space:]]*(brew|cask|tap|mas):' "$OPTIONAL" || true)"

if [ -z "$ENTRIES" ]; then
	info "Brewfile.optional has no entries. Skipping."
	exit 0
fi

# Decide what to install.
SELECTED=""
case "$MODE" in
	all)
		info "Installing all optional entries (--all)..."
		SELECTED="$ENTRIES"
		;;
	none)
		info "Skipping optional picker (--none)."
		exit 0
		;;
	interactive)
		if ! command_exists fzf; then
			warn "fzf not installed — skipping optional picker."
			warn "Run with --all to install everything, or install fzf and re-run."
			exit 0
		fi
		# Only stdin matters — fzf renders its UI to /dev/tty regardless of
		# stdout (which may be tee'd to a log when called from setup.sh).
		if [ ! -t 0 ]; then
			warn "Non-interactive stdin — skipping optional picker."
			warn "Re-run interactively, or pass --all."
			exit 0
		fi

		info "Choose optional packages..."
		# fzf outputs the full row; the first tab field is the original entry.
		PICKER_ENTRIES="$(printf '%s\n' "$ENTRIES" | while IFS= read -r line; do
			printf '%s\t%s\n' "$line" "$(entry_label "$line")"
		done)"
		SELECTED="$(printf '%s\n' "$PICKER_ENTRIES" | fzf \
			--multi \
			--no-sort \
			--disabled \
			--reverse \
			--height=80% \
			--prompt='Optional packages › ' \
			--pointer='❯' \
			--marker='*' \
			--delimiter=$'\t' \
			--with-nth=2 \
			--bind='space:toggle' \
			--bind='a:toggle-all' \
			--bind='enter:accept' \
			--bind='esc:abort' \
			--header='↑↓ to select, space to toggle, enter to confirm, esc to cancel, a to select/unselect all' \
			--preview-window=down:3:wrap \
			--preview='printf "%s\n" {1}' || true)"
		SELECTED="$(printf '%s\n' "$SELECTED" | cut -f1)"
		;;
esac

if [ -z "$SELECTED" ]; then
	info "No optional packages selected."
	exit 0
fi

# Build a temporary Brewfile and feed it to brew bundle via stdin.
TMP_BUNDLE="$(printf '%s\n' "$SELECTED" | while IFS= read -r line; do
	[ -z "$line" ] && continue
	to_brewfile_line "$line"
done)"

if [ -z "$TMP_BUNDLE" ]; then
	info "No valid entries to install."
	exit 0
fi

info "Installing selected optional packages:"
printf '%s\n' "$TMP_BUNDLE" | sed 's/^/  /'

printf '%s\n' "$TMP_BUNDLE" | brew bundle --file=-
success "Optional packages installed."
