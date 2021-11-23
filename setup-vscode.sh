#!/bin/bash
PRODUCTIVITY=$HOME/productivity
HOMECONFIG=$PRODUCTIVITY/homeconfig
VSCODE_DR=$HOMECONFIG/vscode
cd $VSCODE_DR || exit

which vscode
cp keybindings.json /home/$USER/.config/Code/User


