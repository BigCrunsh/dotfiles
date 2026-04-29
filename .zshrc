# ---- tmux ----
# Auto-attach when not already inside tmux. No exec, so a tmux failure
# falls through to a normal zsh prompt instead of killing the terminal.
if [[ -z $TMUX ]] && command -v tmux >/dev/null; then
    tmux attach || tmux new-session
fi

# ---- PATH / locale / editor ----
export PATH="$HOME/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=vim
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# ---- aliases ----
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias vi=vim

# ---- history ----
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE INC_APPEND_HISTORY

# ---- key bindings: prefix-aware history search on arrow keys ----
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# ---- completion (case-insensitive, zsh-native) ----
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# ---- prompt: user@host  cwd  (git-branch) % ----
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:git:*' actionformats ' (%b|%a)'
setopt PROMPT_SUBST
PROMPT='%n@%m %F{blue}%~%f%F{green}${vcs_info_msg_0_}%f %# '

# ---- pyenv ----
if command -v pyenv >/dev/null; then
    eval "$(pyenv init - zsh)"
fi

# ---- zoxide (smart cd) ----
if command -v zoxide >/dev/null; then
    eval "$(zoxide init zsh)"
fi
