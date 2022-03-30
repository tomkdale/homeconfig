########################################
## Tom's .bashrc
#########################################

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#Use default term colors
 export TERM="xterm-256color" 
#Make 777 permission colors less ugly
LS_COLORS="$LS_COLORS:ow=103;30;01"

# Go specific
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# PATH changes
export PATH=$PATH:$HOME/.local/bin
export PATH=~/.npm-global/bin:$PATH
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Set important environment variables
set -o vi
# Uncomment the following line if you don't like systemctl's auto-paging feature:
export SYSTEMD_PAGER=less
# don't put space started commands in history
export HISTCONTROL=erasedups:ignorespace

# Plugins and extra tools
PRODUCTIVITY=$HOME/productivity
# z jump around
if [ -f $PRODUCTIVITY/z/z.sh ]; then 
    source ~/productivity/z/z.sh 
fi

if which vim > /dev/null ; then
  export EDITOR="vim"
else 
  export EDITOR="vi"
fi

# pushpopt enablement
if command -v pusht > /dev/null ; then 
    touch $HOME/.pushpopt.txt
    export PUSHPOPT=~/.pushpopt.txt
fi

#Aliases
alias python="python3 "
alias o="oc "
alias g="git "
alias p="podman "
alias v="vim -v "
alias vi="vim -v"
alias zshconfig="vim ~/.zshrc"
alias info="info --vi-keys"
alias la="ls -alh"
alias open="xdg-open"
alias xclip="xclip -selection clipboard"
alias lh="ls -hl"
alias whaoami="whoami"
alias whaomi="whoami"
alias whomai="whoami"
alias l="ls -lhta"
alias sc="shellcheck"
alias bush="tree -L 2"
alias beep1="aplay -q /usr/share/sounds/speech-dispatcher/guitar-12.wav"
alias beep2="aplay -q /usr/share/sounds/speech-dispatcher/guitar-13.wav"
alias beep="beep1"
alias findr="find -name"
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
alias oginfo="oc get clusterversion --show-labels=true"
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
alias ogproxy="oc proxy --port=8080"
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
alias ogworkloads="oc get projects | grep -v openshift | grep -v kube"

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

ogencrypted()
{
    oc get kubeapiserver -o=jsonpath='{range .items[0].status.conditions[?(@.type=="Encrypted")]}{.reason}{"\n"}{.message}{"\n"}'
}

ognode()
{
    oc get $(oc get nodes -o name | tail -n 1 ) -o jsonpath={.metadata.labels} | jq
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

