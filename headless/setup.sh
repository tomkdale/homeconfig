#!/bin/bash
set -xe
if [ $# -ne 2 ]; then
				echo " Please pass in username and machine ip as arguments"
				exit 1
fi

scp .??* $1@$2:~/ 
ssh $1@$2 " cd $HOME ; git clone https://github.com/christoomey/vim-tmux-navigator.git ~/.vim/pack/plugin/start/"
