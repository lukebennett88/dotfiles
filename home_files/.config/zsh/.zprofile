# Executed at login. Environmental variables set here will be available to
# graphical applications and all shell sessions.

# Set Homebrew path based on system architecture
if [[ $(uname -m) == 'arm64' ]]; then
	# Apple Silicon Mac
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	# Intel Mac
	eval "$(/usr/local/bin/brew shellenv)"
fi

# Set XDG directories for consistent file organisation
export XDG_CACHE_HOME="$HOME/.cache"				# Cache files (~/.cache)
export XDG_CONFIG_HOME="$HOME/.config"			# Config files (~/.config)
export XDG_DATA_HOME="$HOME/.local/share"		# Application data (~/.local/share)
export XDG_STATE_HOME="$HOME/.local/state"	# State files (~/.local/state)

# Add local bin directory to PATH
export PATH="$HOME/.local/bin:$PATH"
