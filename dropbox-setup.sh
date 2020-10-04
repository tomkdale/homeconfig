#!/bin/bash
#########################################
# todo.txt with dropbox
#########################################
# install dropbox (headless 64bit)
PRODUCTIVITY=$HOME/productivity
HOMECONFIG=$PRODUCTIVITY/homeconfig

cd $HOME  || exit

#install and start drobox service
wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

./dropbox-dist/dropboxd
sudo cp $HOMECONFIG/dropbox@.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable dropbox@tdale
sudo systemctl start dropbox@tdale

#install todo.txt-cli which is tracked as plaintext by dropbox
cd $PRODUCTIVITY || exit
git clone git@github.com:todotxt/todo.txt-cli.git
cd todo.txt-cli || exit
make
#Config dif location is tmp becuase its never used. The alias in .zshrc specifies to use ~/.todoconfig as the config file.
make install CONFIG_DIR=/tmp INSTALL_DIR=~/.local/bin BASH_COMPLETION=~/.oh-my-zsh/completions
 
