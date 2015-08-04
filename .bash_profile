# colors

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

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

# docker

$(boot2docker shellinit 2> /dev/null)

# includes

source ~/.common.shellrc
