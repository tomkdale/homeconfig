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


#########################################
# Apply gnome setting that I like
#########################################

dconf write 
