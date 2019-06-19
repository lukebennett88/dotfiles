#!/bin/bash

# Home folder
ln -s -f $HOME/.dotfiles/.bash_profile $HOME/.bash_profile
ln -s -f $HOME/.dotfiles/.gitattributes $HOME/.gitattributes
ln -s -f $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
ln -s -f $HOME/.dotfiles/.gitignore $HOME/.gitignore
ln -s -f $HOME/.dotfiles/.hushlogin $HOME/.hushlogin
ln -s -f $HOME/.dotfiles/.eslintrc $HOME/.eslintrc

# Fish
ln -s -f $HOME/.dotfiles/fish $HOME/.config/

# Set up Fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Set up node
nvm use lts
