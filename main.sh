#!/bin/bash
#########################################
# One stop shop to get my entire environment set up on any dirstro (the goal)
# Tom Dale
#########################################

HOMECONFIG=$HOME/productivity/homeconfig
cd $HOMECONFIG
#########################################
# Link all dotfiles to homedir
#########################################
echo 'Making soft links to these dotfiles from $HOME'
for file in $( ls -apd .?* |  grep -v / |  grep -v .sw ) ; do
  ln -sfv "$HOMECONFIG/$file" "$HOME/$file"
done

#########################################
#Install a bunch of things
#########################################
echo 'Install packages via bash'
sh ./install_pacs.sh

echo 'Start ansible automation section'
ansible-playbook local.yml

#########################################
# Git things
#########################################

echo 'Set up git credentials if not already done'
./git-add-key.sh


#########################################
#Configure keyboard changes
#########################################
#if Gnome
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
#Gnome Setting Changes
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"
fi

#########################################
# zsh things	
#########################################
#install zsh
cd $HOME 
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


#########################################
# vim things
#########################################


#########################################
# tmux things
#########################################
