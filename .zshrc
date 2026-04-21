# Enable instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Early PATH setup
export PATH="$HOME/bin:/usr/local/bin:/opt/homebrew/bin:$PATH"

# oh-my-zsh update behavior
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

# History
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

unset MAILCHECK

plugins=(
    git
    node
    npm
    docker
    docker-compose
    vscode
    zsh-autosuggestions
    zsh-syntax-highlighting
    web-search
    copypath
    copyfile
    dirhistory
    history
    jsontools
    colored-man-pages
    command-not-found
    zsh-completions
)

autoload -Uz compinit
compinit

source $ZSH/oh-my-zsh.sh

# Aliases & secrets
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.secrets ] && source ~/.secrets

# Editor
export EDITOR='cursor'
export VISUAL='cursor'

# Ruby (rbenv via Homebrew)
export RBENV_ROOT=/opt/homebrew/opt/rbenv
if [ -d "$RBENV_ROOT" ]; then
  export PATH="$RBENV_ROOT/bin:$PATH"
  eval "$(/opt/homebrew/opt/rbenv/bin/rbenv init - zsh)"
fi

# Node (nvm via Homebrew)
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Python (pyenv, lazy-loaded)
export PATH="$HOME/.pyenv/bin:$PATH"
pyenv() {
    unset -f pyenv
    eval "$(command pyenv init -)"
    eval "$(command pyenv virtualenv-init -)"
    pyenv "$@"
}

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Cargo / Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Nix
[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ] && \
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# direnv
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# Docker CLI completions
fpath=($HOME/.docker/completions $fpath)

# Editor CLIs on PATH
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:/Applications/Cursor.app/Contents/Resources/app/bin"
export PATH="$HOME/.claude/local:$PATH"

# Autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^H' backward-delete-char

# Small utilities
mkcd() { mkdir -p "$@" && cd "$@"; }

extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)          echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Terminal colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Machine-local overrides (not tracked)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --preview 'bat --style=numbers --color=always --line-range :500 {}'
"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fe() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-cursor} "$file"
}

fbr() {
  local branches branch
  branches=$(git branch -a) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

fco() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

function fd() {
    local dir
    dir=$(find $HOME/* -maxdepth 3 \
        -path '*/\.*' -prune \
        -o -type d -print 2> /dev/null | \
        fzf +m \
            --preview 'tree -C {} | head -200' \
            --preview-window=right:50% \
            --bind='ctrl-d:preview-page-down' \
            --bind='ctrl-u:preview-page-up' \
            --height=80% \
            --layout=reverse \
            --border \
            --prompt="🔍 ")
    [ -n "$dir" ] && cd "$dir"
}

# AWS SSM session to the adreel-app EC2 instance
adreel() {
  local region="us-east-1"
  local profile="${AWS_PROFILE:-adreel}"
  local id
  id="$(AWS_PAGER="" aws --profile "$profile" --region "$region" ec2 describe-instances \
    --filters "Name=tag:Name,Values=adreel-app" "Name=instance-state-name,Values=running" \
    --query "Reservations[0].Instances[0].InstanceId" --output text)"

  if [[ -z "$id" || "$id" == "None" ]]; then
    echo "No running EC2 instance found with tag Name=adreel-app in $region (profile=$profile)"
    return 1
  fi

  AWS_PAGER="" aws --profile "$profile" --region "$region" ssm start-session --target "$id"
}

# Railway SSH / console helpers — expect tokens exported from ~/.secrets
alias adreel_ssh='cd ~/projects/boilerplate && RAILWAY_API_TOKEN=$ADREEL_RAILWAY_TOKEN railway ssh --service web'
alias adreel_rails_c='cd ~/projects/boilerplate && RAILWAY_API_TOKEN=$ADREEL_RAILWAY_TOKEN railway ssh --service web'
alias promptzone_ssh='cd ~/projects/promptzone_community && RAILWAY_API_TOKEN=$PROMPTZONE_RAILWAY_TOKEN railway ssh --service web'
