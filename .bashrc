# If zsh exists and we're in an interactive shell, switch to zsh
if [ -x "$(command -v zsh)" ] && [ -n "$PS1" ]; then
    exec zsh
fi
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
