#!/bin/bash

# Variables
df=~/.dotfiles
files=".bash_profile .eslintrc.js .gitconfig .hushlogin .inputrc .stylelintrc .vimrc .hyper.js"
fish=~/.dotfiles/fish
functions="c.fish cd.fish f.fish terminate.fish"

# Lets make it look nicer
echo ""
echo "- - - - - - - - - -"
echo ""

# change to the dotfiles directory
echo "Changing to the $df directory"
cd $df

# Lets make it look nicer
echo ""
echo "- - - - - - - - - -"
echo ""

# Create symlinks
for file in $files; do
  echo "Creating symlink to $file in home directory"
  ln -s $df/$file ~/$file
  echo "- - -"
done

for file in $functions; do
  echo "Creating symlink to  in home directory."
  ln -s $fish/$function ~/.config/fish/functions/$function
  echo "- - -"
done

# Lets make it look nicer
echo ""
echo "- - - - - - - - - -"
echo ""
echo "All done!"
echo " "
echo "- - - - - - - - - -"
echo ""
