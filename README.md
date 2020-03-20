# homedir

Tom's dotfiles held here, do this on new machine install. IF configuring a server (no X windows) then do the following from server/ .

```
$ install git and login
$ mkdir productivity/
$ git clone https://github.com/tomkdale/homedir ./github/
$ cp github/homedir/.[Xa-z]* .
$ bin/,configurevim
```
Also need to clone 
 - git@github.com:agkozak/zsh-z.git
 - git@github.com:ohmyzsh/ohmyzsh.git

Not done from terminal:
 - Switch esc and caps lock in gnome tweaks
 - Login to firefox or enable: vimium, ghostery, 1password, web search navigator.


//TODO
#configure ansible to do all this
#add the following useful plugins
# z
# how2
# tree
# tmux
# take oh my zsh out of this dir. Should only have configs and scripts to automatically pull this data from github
# notes and vimwiki
