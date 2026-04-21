# Load .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi

# Python (pyenv)
export PATH="$HOME/.pyenv/bin:$PATH"
if command -v pyenv >/dev/null; then
    eval "$(pyenv init --path)"
    pyenv commands | grep -q virtualenv-init && eval "$(pyenv virtualenv-init -)"
fi

# Ruby (rbenv)
command -v rbenv >/dev/null && eval "$(rbenv init -)"

# Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
