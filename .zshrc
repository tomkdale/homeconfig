# #########################################
# Tom's .zshrc
# #########################################

#Colors
 export TERM="xterm-256color" 
#make 777 file color less ugly with ls
LS_COLORS="$LS_COLORS:ow=103;30;01"


# Go specific
export GOPATH=$HOME/go
GOROOT=/usr/lib/golang
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# PATH changes
export PATH=$PATH:$HOME/.local/bin
export ZSH="$HOME/.oh-my-zsh"

#Shell THEMES
ZSH_THEME=candy

# zsh completions
autoload -U compinit && compinit
zstyle ':completion:*' menu select
 HYPHEN_INSENSITIVE="true"
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/odo odo

# enable command auto-correction.
 ENABLE_CORRECTION="true"

# display red dots whilst waiting for completion.
 COMPLETION_WAITING_DOTS="true"

#zsh plugins
plugins=(git helm history sudo oc kubectl dnf pip )
source $ZSH/oh-my-zsh.sh

# z jump around
source ~/productivity/z/z.sh

# Show k8s status in term
#export KUBE_PS1_BINARY=oc
#source $HOME/productivity/kube-ps1/kube-ps1.sh
#PROMPT='$(kube_ps1)'$PROMPT

#npm
export PATH=~/.npm-global/bin:$PATH
# Preferred editor for local and remote sessions
if which gvim > /dev/null ; then
  export EDITOR='gvim -v'
elif which vim > /dev/null ; then
  export EDITOR="vim"
else 
  export EDITOR="vi"
fi

# don't put space started commands in history
export HISTCONTROL=erasedups:ignorespace

#fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# pushpopt
export PUSHPOPT=~/.pushpopt.txt

# Add Reverse i search functionality
bindkey -v
bindkey '^R' history-incremental-search-backward


#Aliases
alias python="python3 "
alias o="oc "
alias g="git "
alias p="podman "
alias v="vim -v "
alias vi="vim -v"
alias zshconfig="vim ~/.zshrc"
set -o vi
alias info="info --vi-keys"
alias la="ls -alh"
alias open="xdg-open"
alias xclip="xclip -selection clipboard"
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
alias ogex="oc extract secret/pull-secret -n openshift-config  --confirm"
alias ogpa="oc get packagemanifests"
alias ogbadpod="oc get pods -A -o wide | grep -vE '(Running|Completed)'"
alias ogbadpods="oc get pods -A -o wide | grep -vE '(Running|Completed)'"
alias ognodeips="oc get nodes  -o jsonpath='{.items[*].status.addresses[?(@.type==\"InternalIP\")].address}'"
alias ogimages="oc get pods -o jsonpath="{..image}" | tr -s '[[:space:]]' '\n' | sort | uniq -c"
alias ogimage="oc get pods -o jsonpath="{..image}" | tr -s '[[:space:]]' '\n' | sort | uniq -c"
alias ogreg="oc get configs.imageregistry.operator.openshift.io cluster -o jsonpath="{..managementState}" "
alias oglabel="oc get clusterversion version --show-labels"
alias oglabels="oc get clusterversion version --show-labels"
alias ogetcd="oc get --raw=/healthz/etcd"
alias gitjd="git checkout jenkins-devtest"
alias gitj="git checkout jenkins"
alias gitm= "git checkout master"
alias ogworkloads="oc get projects | grep -v openshift | grep -v kube"

#More Aliases

alias todo="todo.sh -d ~/.todo "
alias todoa="todo.sh -d ~/.todo list "
alias todow="todo.sh -d ~/.todo list | grep work"
alias todop='todo.sh -d ~/.todo list | grep -E "productivity|personal|prod"'
alias versino="version"
alias ezshrc="vi ~/.zshrc"
alias szshrc="source ~/.zshrc"
alias ogconsole='xdg-open "http://$(ogurl)"'
alias ogtd="oc login -u tdale -p helloavacado" # Throwaway passwrd
alias ogipsec="oc get pods -n openshift-ovn-kubernetes | grep ipsec"
alias ogpodcpu="oc adm top pods -A | sort -k 3 -g -r | head -n 20"
alias ogpodmem="oc adm top pods -A | sort -k 4 -g -r | head -n 20"


#Alias functions
ognfs()
{
    oc get pods -n openshift-nfs-storage -o yaml | grep "server:"
}

ogcon()
{
  echo "KUBECONFIG=$KUBECONFIG"
  oc config view | grep "current-context"
}
ogco() 
{
   oc get co -o go-template='{{- range .items -}}{{- $available := "Unknown" -}}{{- $message := "" -}}{{- range .status.conditions -}}{{- if eq .type "Available" -}}{{- $available = .status -}}{{- $message = .message -}}{{- end -}}{{- end -}}{{- if or (eq $available "False") (eq $available "Unknown") -}}{{- print "===== " .metadata.name " =====\n" $message "\n" -}}{{- end -}}{{- end -}}'
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
  oc login --server=9.12.23."$1":6443 -u tdale
}

ogdebug()
{
  kubectl run -i --rm --tty debug --image=praqma/network-multitool --restart=Never -- sh 
}

ognetwork() 
{
  oc get network.config/cluster -o jsonpath='{.status.networkType}{"\n"}'
}

ogbadco()
{
  oc get co | grep -v "True        False         False"
}

cddir ()
{
    mkdir -p -- "$1" &&
      cd -P -- "$1"
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

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/tdale/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/tdale/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/tdale/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/tdale/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

