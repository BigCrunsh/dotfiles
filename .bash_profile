# start tmux by default
if [[ ! $TERM =~ screen ]]; then
    exec tmux
fi

# base
export PATH=~/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/local/bin:/opt/local/sbin:~/src/gocode/bin/
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR="vim"
export TERM=screen-256color # xterm-256color

# autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# java
export JAVA_HOME=$(/usr/libexec/java_home)

# go
export PATH=$PATH:/usr/local/go/bin
export GOPATH=~/src/gocode

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
alias vim='/usr/local/bin/vim' # don't use OSX built-in vim
alias git=hub

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

# ssh agent
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l | grep "The agent has no identities" && ssh-add

# gnu tools
if which gls > /dev/null; then alias ls=gls; fi
if which gdircolors > /dev/null; then alias dircolors=gdircolors; fi
