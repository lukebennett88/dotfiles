#!/bin/bash
set -euo pipefail

source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

info "Applying macOS defaults..."

# -- General / launch services -----------------------------------------------
# Skip the "Are you sure you want to open this app?" prompt for downloaded binaries
defaults write com.apple.LaunchServices LSQuarantine -bool false

# -- Keyboard ----------------------------------------------------------------
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Tab through all controls in dialogs, not just text fields
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# -- Dock --------------------------------------------------------------------
defaults write com.apple.dock tilesize -int 37
defaults write com.apple.dock show-recents -bool false

# -- Appearance --------------------------------------------------------------
# Auto-switch Light/Dark based on time of day. AppleInterfaceStyle must NOT be
# explicitly set, otherwise the auto-switch key is ignored.
defaults delete NSGlobalDomain AppleInterfaceStyle 2>/dev/null || true
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# -- Finder ------------------------------------------------------------------
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Column view by default
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When searching, default to the current folder (not "This Mac")
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# New Finder windows open at $HOME
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Stop polluting network and USB drives with .DS_Store
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# -- Screenshots -------------------------------------------------------------
mkdir -p "$HOME/Downloads"
defaults write com.apple.screencapture location -string "$HOME/Downloads"

# -- Software updates --------------------------------------------------------
# Daily check + auto-install for App Store apps
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
defaults write com.apple.commerce AutoUpdate -bool true

# -- Apply -------------------------------------------------------------------
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

success "macOS defaults applied."
