#!/bin/bash

# Dock
#
# System Preferences > Dock > Size:
defaults write com.apple.dock tilesize -int 36
# System Preferences > Dock > Magnification:
defaults write com.apple.dock magnification -bool true
# System Preferences > Dock > Size (magnified):
defaults write com.apple.dock largesize -int 54
# System Preferences > Dock > Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true
# System Preferences > Dock > Show indicators for open applications
defaults write com.apple.dock show-process-indicators -bool true
# System Preferences > Mission Control > Automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false
# Clear out the dock of default icons
defaults delete com.apple.dock persistent-apps
defaults delete com.apple.dock persistent-others
# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Keyboard & trackpad settings
#
# System Preferences > Keyboard >
defaults write NSGlobalDomain KeyRepeat -int 2
# System Preferences > Keyboard >
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# System Preferences > Trackpad > Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Finder
#
# Finder > Preferences > Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Finder > Preferences > Show wraning before changing an extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Finder > Preferences > Show wraning before removing from iCloud Drive
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false
# Hide desktop icons
defaults write com.apple.finder CreateDesktop false
# View as columns
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
# Show path bar
defaults write com.apple.finder ShowPathbar -bool true
# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Prevent .DS_Store files
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Set Home folder as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Save & Print
#
# Expand save and print modals by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# System Preferences
#
# Disable LCD font smoothing (default 4)
defaults -currentHost write -globalDomain AppleFontSmoothing -int 0
# Hot corner: Bottom right, put display to sleep
defaults write com.apple.dock wvous-br-corner -int 10
defaults write com.apple.dock wvous-br-modifier -int 0
# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
# Disable keyboard autocorrect
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true
# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Safari
#
# Press Tab to highlight each item on a web page
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true
# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false
# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Terminal
#
# Disable the annoying line marks
defaults write com.apple.Terminal ShowLineMarks -int 0

# Restart Finder and Dock (though many changes need a restart/relog)
killall Finder
killall Dock
