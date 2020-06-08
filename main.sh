#!/bin/bash
#########################################
# One stop shop to get my entire environment set up on any dirstro (the goal)
# Tom Dale
#########################################


PRODUCTIVITY=$HOME/productivity
HOMECONFIG=$PRODUCTIVITY/homeconfig
cd $HOMECONFIG

#########################################
#Install a bunch of things
#########################################
echo 'Install packages via bash'
sh ./install_pacs.sh

echo 'Start ansible automation section'
ansible-playbook local.yml

#########################################
# Git things
#########################################

echo 'Set up git credentials if not already done'
./git-add-key.sh


#########################################
# zsh things	
#########################################
#install oh-my-zsh
cd $HOME 
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd $HOMECONFIG


#########################################
# vim things
#########################################
# copy extended vim files to ~.vim/
cp -r  $HOMCONFIG/.vim ~/
# install vimplug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +Pluginstall +qall

#########################################
# tmux things
##########################################


#########################################
# Link all dotfiles to homedir
#########################################
echo 'Making soft links to these dotfiles from $HOME'
for file in $( ls -apd .?* |  grep -v / |  grep -v .sw ) ; do
  ln -sfv "$HOMECONFIG/$file" "$HOME/$file"
done


#########################################
#Configure keyboard changes
#########################################

#if Gnome
echo 'Gnome detected, switching esc and caps lock'
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
#Gnome Setting Changes
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"
fi

########################################
# z jump around
########################################
# Add z jump around tool, this stays here and is added to zshrc
cd $PRODUCTIVITY
git clone https://github.com/rupa/z.git



#########################################
# Todo w dropbox
#########################################
# install dropbox (headless 64bit)
cd $HOME && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
sudo cp $HOMECONFIG/dropbox@.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable dropbox@tdale
sudo systemctl start dropbox@tdale


