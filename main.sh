#!/bin/bash
 
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"
dconf load / < ~/productivity/homedir/dconfSettings
