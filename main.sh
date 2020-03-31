#!/bin/bash
if [ -f /etc/os-release ]; then
  . /etc/os-release
	OS=$NAME	
	echo "Installing on $OS"
else 
  echo '$OS not found' 
	exit 1
fi

if [ $OS == Ubuntu ] || [ $OS == Debian ]; then 
  sudo apt install ansible
elif [ $OS == "Fedora" ] || [ $OS == "RHEL" ] || [ $OS == "Centos" ]; then
	sudo dnf install ansible
fi

./git-add-key.sh
#Gnome Setting Changes
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"
# dconf write /org/gtk/settings/file-chooser/clock-format '12h'

ansible-playbook local.yml
