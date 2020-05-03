#!/bin/bash
#########################################
# One stop shop to get my entire environment set up on any dirstro (the goal)
# Tom Dale
#########################################

HOMECONFIG=$HOME/productivity/homeconfig
cd $HOMECONFIG

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
# zsh things	
#########################################
#install oh-my-zsh
cd $HOME 
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"



#########################################
# vim things
#########################################


#########################################
# tmux things
##########################################


#########################################
# Link all dotfiles to homedir
#########################################
echo 'Making soft links to these dotfiles from $HOME'
for file in $( ls -apd .?* |  grep -v / |  grep -v .sw ) ; do
  ln -sfv "$HOMECONFIG/$file" "$HOME/$file"
done


#########################################
#Configure keyboard changes
#########################################

#if Gnome
echo 'Gnome detected, switching esc and caps lock'
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
#Gnome Setting Changes
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"
fi

########################################
