#!/bin/bash

# Priority
brew install mas
mas install 1333542190 #1Password
brew cask install alfred
brew cask install visual-studio-code

# CLI
brew install fish
brew install git
brew install hugo
brew install node
brew install trash
brew install tree
brew install youtube-dl

# Cask apps
brew cask install cleanmymac
brew cask install google-chrome
brew cask install hazel
brew cask install imageoptim
brew cask install iterm2
brew cask install slack

# Fonts
brew tap homebrew/cask-fonts
brew cask install font-fira-code
brew cask install font-fira-mono-for-powerline
brew cask install font-ibm-plex

# Mac App Store apps
mas install 1107421413 #1Blocker
mas install 1091189122 #Bear
mas install 441258766 #Magnet
mas install 451907568 #Paprika Recipe Manager
mas install 403504866 #PCalc
mas install 1160374471 #PiPifier
mas install 407963104 #Pixelmator
mas install 880001334 #Reeder
mas install 803453959 #Slack
mas install 425424353 #The Unarchiver
mas install 904280696 #Things

# Global Node.js packages
npm i -g npm@latest
npm i -g gatsby-cli@latest
npm i -g netlify-cli@latest
npx install-peerdeps --global eslint-config-wesbos
