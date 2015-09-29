# start tmux by default
if [[ ! $TERM =~ screen ]]; then
    exec tmux
fi

# base
export PATH=~/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
export JAVA_HOME=$(/usr/libexec/java_home)
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR="vim"
export TERM=screen-256color # xterm-256color

# colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# aliases
alias ....="cd ../../.."
alias ...="cd ../.."
alias ..="cd .."
alias clear="echo use CTRL-L instead. && false"
alias gist='gist -p'
alias less='less -r' # interpret color
alias ll='ls --color -bF'
alias tree='tree -C' # color
alias vi='vim'
gitdiffnb() {
		diff <(git show HEAD:$1 | jq .cells[].source) <(cat $1 | jq .cells[].source) | vim -R -
}

# history
shopt -s histappend

export HISTCONTROL=erasedups
export HISTSIZE=10000
export HISTIGNORE=' *'

if tty 1>/dev/null
  then
    bind Space:magic-space
    bind '"\e[A"':history-search-backward
    bind '"\e[B"':history-search-forward
fi

# completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi
for c in ~/.completions/*; do source $c; done

# prompt
GIT_PROMPT_THEME=Single_line_Solarized
source ~/.bash-git-prompt/gitprompt.sh

# gnu tools
if which gls > /dev/null; then alias ls=gls; fi
if which gdircolors > /dev/null; then alias dircolors=gdircolors; fi

# soundcloud specific stuff
source ~/.soundcloud

# docker
dockerMachine=`docker-machine ls | grep Running | head -1 | awk '{ print $1 }'`
if [ $? -ne 0 ] || [ -z "$dockerMachine" ]; then
  dockerMachine=default
  echo start docker machine
  docker-machine start $dockerMachine 1> /dev/null
fi
eval "$(docker-machine env $dockerMachine)"
