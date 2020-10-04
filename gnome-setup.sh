#!/bin/bash

#########################################
# Load all dconf settings over
#########################################
cd $HOMECONFIG || exit
#Load all keybindings
cat dconf-settings.ini | dconf load /
cd $PRODUCTIVITY || exit
git clone https://github.com/paperwm/PaperWM.git 
cd PaperWM || exit
echo "n 
y" | ./install.sh



#// TODO: Need to change this to only add needed things in dconf. Do you really want to delete all existing dconf settings
