#!/bin/bash

# Home folder
ln -s -f $HOME/.dotfiles/.bash_profile $HOME/.bash_profile
ln -s -f $HOME/.dotfiles/.gitattributes $HOME/.gitattributes
ln -s -f $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
ln -s -f $HOME/.dotfiles/.gitignore $HOME/.gitignore
ln -s -f $HOME/.dotfiles/.hushlogin $HOME/.hushlogin

# Fish
ln -s -f $HOME/.dotfiles/fish $HOME/.config/
