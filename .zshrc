# #########################################
# Tom's .zshrc
# #########################################

#Tom's zsh config
 export TERM="xterm-256color" 

# Go specific
export GOPATH=$HOME/go
GOROOT=/usr/lib/golang
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# PATH changes
export PATH=$PATH:$HOME/.local/bin
export ZSH="$HOME/.oh-my-zsh"

# Add Reverse i search functionality
bindkey -v
bindkey '^R' history-incremental-search-backward

#Shell THEMES
ZSH_THEME=robbyrussell

# z jump around
source ~/productivity/z/z.sh

# zsh completions
autoload -U compinit && compinit
zstyle ':completion:*' menu select
 HYPHEN_INSENSITIVE="true"

# enable command auto-correction.
 ENABLE_CORRECTION="true"

# display red dots whilst waiting for completion.
 COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git history docker sudo oc kubectl dnf pip )
source $ZSH/oh-my-zsh.sh

#Adding a space before a command will ignore it from history
 export HISTCONTROL=ignorespace

# Show k8s status in term
export KUBE_PS1_BINARY=oc
source $HOME/productivity/kube-ps1/kube-ps1.sh
PROMPT='$(kube_ps1)'$PROMPT

#make 777 file color less ugly with ls
LS_COLORS="$LS_COLORS:ow=103;30;01"

# Preferred editor for local and remote sessions
export EDITOR='vim'
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/odo odo
# don't put space started commands in history
export HISTCONTROL=erasedups:ignorespace


#fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


#########################################
#Aliases

alias vi="vim"
if command -v nvim > /dev/null ; then
  alias vi="nvim"
  alias vim="nvim"
fi
alias zshconfig="vim ~/.zshrc"
set -o vi
alias info="info --vi-keys"
alias la="ls -alh"
alias open="xdg-open"
alias xclip="xclip -se c"
alias lh="ls -hl"
alias whaoami="whoami"
alias whaomi="whoami"
alias whoami="whoami"
alias whomai="whoami"
alias l="ls -lhta"
alias rf="rm -rf"
alias sc="shellcheck"
alias bush="tree -L 2"
alias beep1="aplay -q /usr/share/sounds/speech-dispatcher/guitar-12.wav"
alias beep2="aplay -q /usr/share/sounds/speech-dispatcher/guitar-13.wav"
alias beep="beep1"
alias findr="find -name"
# Openshift quick help
alias ogres="oc describe nodes | grep Resource -A 5"
alias ogpod="oc get pods"
alias ognod="oc get nodes"
alias ogser="oc get services"
alias ogrou="oc get routes"
alias ogjob="oc get jobs"
alias ogdep="oc get deployments"
alias ogpro="oc get project"
alias ogsec="oc get secrets"
alias ogcro="oc get cronjobs"
alias ogsub="oc get subscriptions"
alias ogall="oc get all"
alias ogver="oc version"
alias ogco="oc get co"
alias ogex="oc extract secret/pull-secret -n openshift-config  --confirm"
alias ogpa="oc get packagemanifests"
alias ogbadpod="oc get pods -A -o wide | grep -vE '(Running|Completed)'"
alias ogbadpods="oc get pods -A -o wide | grep -vE '(Running|Completed)'"

#More Aliases
alias todo="todo.sh -d ~/.todo "
alias todow="todo.sh -d ~/.todo list | grep work"
alias todoo="todo.sh -d ~/.todo list | grep ossm"
alias todop='todo.sh -d ~/.todo list | grep -E "productivity|personal"'
alias oc="oc "
alias versino="version"
alias ezshrc="vi ~/.zshrc"
alias szshrc="source ~/.zshrc"

#alias todols="todo ls | awk '{print $NF,$0}' | sort | cut -f2- -d' ' | grep -v \"TODO: \" "

ogcon()
{
  echo "KUBECONFIG=$KUBECONFIG"
  oc config view | grep "current-context"
}

ogurl()
{
  oc get -n openshift-console route console | tail -n 1 | awk '{print $2}'
}
homeconfigpush()
{
  pushd
  cd ~/productivity/homeconfig
  git add .
  git commit -m "1line push"
  git push
  popd
}

ogallroutes()
{
  oc get routes --all-namespaces | awk '{print $3}'
}

ogset()
{
  if [ ! -f ~/.kube/"$1" ]; then
    touch ~/.kube/"$1"
  fi
  export KUBECONFIG=~/.kube/"$1"
}
oglogin() 
{
  oc login --server=9.12.23."$1":6443
}

ogdebug() { kubectl run -i --rm --tty debug --image=praqma/network-multitool --restart=Never -- sh }

ognetwork() { oc get network.config/cluster -o jsonpath='{.status.networkType}{"\n"}' }


cddir ()
{
    mkdir -p -- "$1" &&
      cd -P -- "$1"
}

vd () 
{
  cd "$1"
  ls 
}


giturl ()
{
  gitremote=$(git remote -v | grep 'fetch' | awk '{print $2}')
  if echo $gitremote | grep 'git@github' > /dev/null ; then
    echo $gitremote | sed  's|git@|https://|g' | sed 's|com:|com/|g'
  elif echo $gitremote | grep 'https://github' > /dev/null ; then
    echo $gitremote
  else 
    echo 'unexpected git remote'
  fi
}

