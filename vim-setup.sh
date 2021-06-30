#!/bin/bash
#########################################
# Configure vim work as expected
# Tom Dale
#########################################
PRODUCTIVITY=$HOME/productivity
HOMECONFIG=$PRODUCTIVITY/homeconfig
VIMHOME=$HOME/.vim
cd $HOMECONFIG || exit


#########################################
# vim things
#########################################
# install vimplug
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall
vim +PlugUpdate +qall

#########################################
# Add filetype vim specifics
#https://vim.fandom.com/wiki/Keep_your_vimrc_file_clean
#########################################
mkdir ~/.vim/ftplugin
for file in $( ls vim ) ; do
  # If there was a .dotfile present move it to .dotfilebackups
  ln -sfv "$HOMECONFIG/vim/$file" "$VIMHOME/ftplugin/$file"
done
