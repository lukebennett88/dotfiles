# Contains all user-defined functions

# Delete all local branches except the specified one (default: main)
gbdm() {
	local keep_branch="${1:-main}"
	git branch | rg -v "^\*?\s*(${keep_branch})\$" | xargs git branch -D
}

# Create a new directory and change to it
mkcd() {
	mkdir -p "$1" && cd "$1"
}

# Extract most know archives with one command
extract() {
	if [ -f $1 ]; then
		case $1 in
			*.tar.bz2)	tar xjf $1		;;
			*.tar.gz)		tar xzf $1		;;
			*.bz2)			bunzip2 $1		;;
			*.rar)			unrar e $1		;;
			*.gz)				gunzip $1			;;
			*.tar)			tar xf $1			;;
			*.tbz2)			tar xjf $1		;;
			*.tgz)			tar xzf $1		;;
			*.zip)			unzip $1			;;
			*.Z)				uncompress $1	;;
			*.7z)				7z x $1				;;
			*)					echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# Safer git clean with preview and confirmation
git_clean_safe() {
	echo "📋 Files that would be deleted:"
	git clean -fxdn

	echo "\n❔ Do you want to proceed with deletion? [y/N] "
	read -k 1 confirm
	echo ""

	if [[ "$confirm" =~ ^[Yy]$ ]]; then
		echo "🗑️  Deleting files..."
		git clean -fxd
		echo "✅ Done!"
	else
		echo "❌ Operation cancelled."
	fi
}
