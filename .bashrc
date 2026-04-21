# If zsh exists and we're in an interactive shell, switch to zsh
if [ -x "$(command -v zsh)" ] && [ -n "$PS1" ]; then
    exec zsh
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -f ~/.secrets ] && source ~/.secrets

alias h2='$(npm prefix -s)/node_modules/.bin/shopify hydrogen'
