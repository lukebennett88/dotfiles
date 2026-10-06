set shell := ["/bin/bash", "-euo", "pipefail", "-c"]

root := justfile_directory()
brewfile := root / "Brewfile"
optional_brewfile := root / "optional" / "Brewfile"
stow_packages := "home bat eza ghostty git lazygit mise starship worktrunk zsh"

default: bootstrap

bootstrap: packages stow runtimes bat-cache

packages:
	brew bundle --file "{{brewfile}}"

optional:
	brew bundle --file "{{optional_brewfile}}"

# Report Homebrew drift against both manifests combined. Never installs or uninstalls.
drift:
	"{{root}}/scripts/drift.sh"

stow:
	"{{root}}/scripts/stow.sh" {{stow_packages}}

runtimes:
	mise install node pnpm

bat-cache:
	bat cache --build

# Validate tracked configs without installing or changing anything.
check:
	"{{root}}/scripts/check.sh" {{stow_packages}}

# Install every entry in skills.txt (one `<source> <skill>...` per line).
skills:
	@"{{root}}/scripts/skills.sh" install

# Report drift between skills.txt and the machine. Read-only.
skills-drift:
	@"{{root}}/scripts/skills.sh" check

agents:
	cd "{{root}}" && stow --restow agents
	mise trust "$HOME/.config/mise/conf.d/agents.toml"
	curl -fsSL https://claude.ai/install.sh | bash
	mise install aube
	just --justfile "{{justfile()}}" skills

macos:
	bash "{{root}}/scripts/setup-macos-defaults.sh"
