#!/bin/bash

# CLI
brew install bash-completion
brew install cowsay
brew install fish
brew install git
brew install hugo
brew install mas
brew install node
brew install trash
brew install tree
brew install yarn
brew install youtube-dl

# Cask apps
brew cask install alfred
brew cask install cleanmymac
brew cask install google-chrome
brew cask install hazel
brew cask install imageoptim
brew cask install iterm2
brew cask install slack
brew cask install visual-studio-code

# Fonts
brew tap homebrew/cask-fonts
brew cask install font-ibm-plex

# Mac App Store apps
mas install 1107421413 #1Blocker
mas install 1333542190 #1Password
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
mas install 1384080005 #Tweetbot

# Global Node.js packages
yarn global add @11ty/eleventy autoprefixer babel-eslint eslint eslint-config-airbnb eslint-config-prettier eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-prettier eslint-plugin-react gatsby-cli postcss-cli prettier surge
