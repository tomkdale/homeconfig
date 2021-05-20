#!/bin/bash
#########################################
# One stop shop to get my entire environment set up on any dirstro (the goal)
# Tom Dale
#
#########################################
PRODUCTIVITY=$HOME/productivity
HOMECONFIG=$PRODUCTIVITY/homeconfig
cd $HOMECONFIG || exit
# Most binaries will be added to $HOME/.local/bin/
DOTLOCALBIN=$HOME/.local/bin/
mkdir -p $DOTLOCALBIN
if [ -d "$DOTLOCALBIN" ] && [[ ":$PATH:" != *":$DOTLOCALBIN:"* ]]; then
				PATH="${PATH:+"$PATH:"}$DOTLOCALBIN"
fi

#########################################
#Install a bunch of things
#########################################
echo 'Install packages via bash'
bash ./scripts/install_pacs.sh || exit 77

#########################################
# Link all dotfiles to $HOME/.* and $HOME/.config/*
#########################################
echo 'Making soft links to these dotfiles from $HOME'
mkdir $HOME/.dotfilebackups
for file in $( ls -apd .?* |  grep -v / |  grep -v .sw ) ; do
  # If there was a .dotfile present move it to .dotfilebackups
  mv "$HOME/$file" "$HOME/.dotfilebackups" 2> /dev/null
  ln -sfv "$HOMECONFIG/$file" "$HOME/$file"
done
ln -sfv "$HOMECONFIG/i3/config $HOME/.config/i3/config"
if ps -e | grep -E -i "i3" ; then 
  echo "if using i3 run meta+shift+R to reload new i3config"
fi

#########################################
# Git things
#########################################
echo 'Set up git credentials if not already done'
if ./scripts/git-add-key.sh ; then
				git remote set-url origin git@github.com:tomkdale/homeconfig.git
fi

#########################################
# zsh things	
#########################################
#install oh-my-zsh
cd $HOME  || exit
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#########################################
# vim things
#########################################
# install vimplug
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall
vim +PlugUpdate +qall
#########################################
# tmux things
##########################################
mkdir $HOME/.tmux
TMUXHOME=$HOME/.tmux
## kube-tmux
cd $TMUXHOME || exit
git clone https://github.com/jonmosco/kube-tmux.git 

#########################################
#Configure keyboard changes
#########################################
#if Gnome
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
				#Gnome Setting Changes
				echo 'Gnome detected, switching esc and caps lock'
				dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"
else 
				echo 'Gnome not detected. Did not switch caps:escape'
fi

########################################
# z jump around
########################################
# Add z jump around tool, this stays here and is added to zshrc
cd $PRODUCTIVITY || exit
git clone https://github.com/rupa/z.git

#########################################
# Install Baker
#########################################
curl -fLo $HOME/.local/bin/baker https://raw.github.com/tomkdale/Baker/master/baker 
chmod +x $HOME/.local/bin/baker


#########################################
## Other installation steps
#########################################
echo "Now proceed with any applicable *-setup.sh scripts"
