#Tom's zsh config
 export TERM="xterm-256color" 
 export JAVA_HOME=/usr/local/java/jdk-13.0.1
 export PATH=$HOME/bin:/usr/local/bin:$PATH:$JAVA_HOME
# Path to your oh-my-zsh installation.
export ZSH="/home/tdale/.oh-my-zsh"
# Add Reverse i search functionality
bindkey -v
bindkey '^R' history-incremental-search-backward
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
ZSH_THEME="powerlevel9k/powerlevel9k"

source ~/productivity/z/z.sh
autoload -U compinit && compinit
zstyle ':completion:*' menu select
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
 HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to enable command auto-correction.
 ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
 COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git kubectl podman history adb alias-finder docker encode64 lol helm sudo vscode web-search oc )
#                                                                                              Please keep this one last ^^^^^^^
source $ZSH/oh-my-zsh.sh

########################################## User configuration
if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/share/powerline/bash/powerline.sh
fi
#export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

 alias zshconfig="vim ~/.zshrc"
set -o vi
alias la="ls -alh"
alias open="xdg-open"
alias xclip="xclip -se c"
alias :wq="exit"
alias lh="ls -hl"
alias whaoami="whoami"
alias whaomi="whoami"
alias vi="vim"
alias l="ls -lhta"
alias rf="rm -rf"
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/odo odo
# don't put space started commands in history
export HISTCONTROL=erasedups:ignorespace
