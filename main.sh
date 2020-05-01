#!/bin/bash
#########################################
# One stop shop to get my entire environment set up on any dirstro (the goal)
# Tom Dale
#########################################

# Link all dotfiles to homedir
for file in $( ls -apd .?* |  grep -v / |  grep -v .sw | grep -v .gitconfig) ; do
  ln -sv "~/productivity/homedir/$file" "$HOME"
done

#Install a bunch of things, most importantly: ansible
sh ./install_pacs.sh

#Run ansible
ansible-playbook local.yml

./git-add-key.sh


#if Gnome
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
#Gnome Setting Changes
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"
fi


#install zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

