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

# ---- prompt: robbyrussell-style + venv + indicators + duration ----
# Shape:   (venv) ➜  basename [@host on SSH] git:(branch) ✗ … ⚑1 ↑2 [bg N]
# Right:   duration of the previous command if it took ≥ 2s
# Git indicators (only shown when applicable):
#   ✗ unstaged   ● staged    … untracked   ⚑N stashes   ↑N/↓N ahead/behind
zmodload zsh/datetime
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr   '_S_'   # placeholder; consumed by hook
zstyle ':vcs_info:*' unstagedstr '_U_'   # placeholder; consumed by hook
zstyle ':vcs_info:git:*' formats       ' %F{blue}git:(%F{red}%b%F{blue})%f%m'
zstyle ':vcs_info:git:*' actionformats ' %F{blue}git:(%F{red}%b|%F{yellow}%a%F{blue})%f%m'

+vi-git-indicators() {
    local -a parts
    [[ -n ${hook_com[unstaged]} ]] && parts+=( '%F{yellow}✗%f' )
    [[ -n ${hook_com[staged]}   ]] && parts+=( '%F{green}●%f' )
    if git status --porcelain 2>/dev/null | grep -q '^??'; then
        parts+=( '%F{cyan}…%f' )
    fi
    local stashed ahead behind
    stashed=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
    (( stashed > 0 )) && parts+=( "%F{magenta}⚑${stashed}%f" )
    if git rev-parse --abbrev-ref '@{upstream}' &>/dev/null; then
        ahead=$(git rev-list --count '@{upstream}..HEAD' 2>/dev/null) || ahead=0
        behind=$(git rev-list --count 'HEAD..@{upstream}' 2>/dev/null) || behind=0
        (( ahead > 0 ))  && parts+=( "↑${ahead}" )
        (( behind > 0 )) && parts+=( "↓${behind}" )
    fi
    (( ${#parts[@]} > 0 )) && hook_com[misc]=' '${(j: :)parts}
}
zstyle ':vcs_info:git*+set-message:*' hooks git-indicators

# Python venv / conda env / pyenv (shown only when explicitly active, not global)
_prompt_pyenv() {
    local v
    if [[ -n $VIRTUAL_ENV ]]; then
        v=${VIRTUAL_ENV:t}
    elif [[ -n $CONDA_DEFAULT_ENV && $CONDA_DEFAULT_ENV != "base" ]]; then
        v=$CONDA_DEFAULT_ENV
    elif command -v pyenv >/dev/null \
         && { [[ -n $PYENV_VERSION ]] || pyenv local 2>/dev/null >/dev/null; }; then
        v=$(pyenv version-name 2>/dev/null)
        [[ $v == "system" ]] && v=""
    fi
    [[ -n $v ]] && print -n "%F{green}(${v})%f "
}

# Command duration on RPROMPT (only when ≥ 2s)
preexec() { _cmd_start=$EPOCHSECONDS }
_prompt_duration() {
    [[ -z ${_cmd_start:-} ]] && { _cmd_dur=""; return; }
    local d=$(( EPOCHSECONDS - _cmd_start ))
    unset _cmd_start
    if   (( d < 2 ));    then _cmd_dur=""
    elif (( d < 60 ));   then _cmd_dur="${d}s"
    elif (( d < 3600 )); then _cmd_dur="$((d/60))m$((d%60))s"
    else                      _cmd_dur="$((d/3600))h$((d%3600/60))m"
    fi
}
precmd() { vcs_info; _prompt_duration }

setopt PROMPT_SUBST

# Host segment: yellow @fqdn on SSH, hidden when local
if [[ -n $SSH_CONNECTION || -n $SSH_TTY ]]; then
    _PROMPT_HOST=' %F{yellow}@%M%f'
else
    _PROMPT_HOST=''
fi

PROMPT='$(_prompt_pyenv)%(?.%F{green}.%F{red})➜%f  %F{cyan}%1~%f${_PROMPT_HOST}${vcs_info_msg_0_}%(1j. %F{magenta}[bg %j]%f.) '
RPROMPT='%F{8}${_cmd_dur}%f'

# ---- pyenv ----
if command -v pyenv >/dev/null; then
    eval "$(pyenv init - zsh)"
fi

# ---- zoxide (smart cd) ----
if command -v zoxide >/dev/null; then
    eval "$(zoxide init zsh)"
fi
# ---- google cloud sdk ----
if command -v brew >/dev/null && [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]; then
    source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
    source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi

# ---- zsh plugins: autosuggestions + syntax highlighting ----
# Highlighting MUST be sourced last (zsh-syntax-highlighting upstream guidance).
if command -v brew >/dev/null; then
    [ -r "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
        source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [ -r "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
        source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
