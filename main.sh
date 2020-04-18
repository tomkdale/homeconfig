#!/bin/bash
#########################################
# One stop shop to get my entire environment set up on any dirstro (the goal)
# Tom Dale
#########################################

sh ./install_pacs.sh
#Get distro 
if [ -f /etc/os-release ]; then
  . /etc/os-release
	DISTRO=$NAME	
	echo "Installing on $DISTRO"
else 
  echo "$DISTRO not found"
	exit 1
fi

#install ansible then run ansible to get all package manabment 
if [ $DISTRO == Ubuntu ] || [ $DISTRO == Debian ]; then 
  sudo apt install ansible
elif [ $DISTRO == "Fedora" ] || [ $DISTRO == "RHEL" ] || [ $DISTRO == "Centos" ]; then
	sudo dnf install ansible
fi

ansible-playbook local.yml

./git-add-key.sh

#Gnome Setting Changes
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"
# dconf write /org/gtk/settings/file-chooser/clock-format '12h'

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
