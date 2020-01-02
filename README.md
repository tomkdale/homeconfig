# homedir

Tom's dotfiles held here, do this on new machine install

```
$ mkdir github/
$ git clone https://github.com/tomkdale/homedir ./github/
$ cp github/homedir/.[Xa-z]* .
$ bin/,configurevim
$ rm -r github/homedir
```
Also need to clone 
 - git@github.com:agkozak/zsh-z.git
 - git@github.com:ohmyzsh/ohmyzsh.git

In servers change tmux to use ctr-a as prefex by adding the following to .tmux.conf
```
# remap prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix
```
