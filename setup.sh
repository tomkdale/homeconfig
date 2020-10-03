#!/bin/bash
#########################################
# One stop shop to get my entire environment set up on any dirstro (the goal)
# Tom Dale
#
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
# Link all dotfiles to homedir
#########################################
echo 'Making soft links to these dotfiles from $HOME'
mkdir $HOME/.dotfilebackups
for file in $( ls -apd .?* |  grep -v / |  grep -v .sw ) ; do
  # If there was a .dotfile present move it to .dotfilebackups
  mv "$HOME/$file" "$HOME/.dotfilebackups" 2> /dev/null
  ln -sfv "$HOMECONFIG/$file" "$HOME/$file"
done


#########################################
# Git things
#########################################

echo 'Set up git credentials if not already done'
if ./scripts/git-add-key.sh ; then
				git remote set-url origin git@github.com:tomkdale/homeconfig.git
fi

#########################################
# Powerline things
#########################################
sudo pip3 install powerline-status

#########################################
# zsh things	
#########################################
#install oh-my-zsh
cd $HOME  || exit
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

#########################################
# vim things
#########################################
# install vimplug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +Pluginstall +qall
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
# todo.txt with dropbox
#########################################
# install dropbox (headless 64bit)
cd $HOME  || exit
wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
sudo cp $HOMECONFIG/dropbox@.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable dropbox@tdale
sudo systemctl start dropbox@tdale

cd $PRODUCTIVITY || exit
git clone git@github.com:todotxt/todo.txt-cli.git
cd todo.txt-cli || exit
make
#Config dif location is tmp becuase its never used. The alias in .zshrc specifies to use ~/.todoconfig as the config file.
make install CONFIG_DIR=/tmp INSTALL_DIR=~/.local/bin BASH_COMPLETION=~/.oh-my-zsh/completions

#########################################
# Install Baker
#########################################

 
#########################################
# Install paperwm
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
# autostart (do I really want this?)
#########################################
# copy over the basic applications to autostart
#cd $HOMECONFIG || exit
#cp autostart/* $HOME/.config/autostart/
