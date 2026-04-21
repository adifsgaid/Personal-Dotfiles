#!/usr/bin/env zsh
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Files that get symlinked from this repo into $HOME.
DOTFILES=(
  .zshrc
  .aliases
  .functions
  .gitconfig
  .gitignore
  .vimrc
  .bashrc
  .bash_profile
  .macos
)

confirm() {
  [[ "${1:-}" == "--force" || "${1:-}" == "-f" ]] && return 0
  read "REPLY?This will overwrite dotfiles in \$HOME. Continue? (y/n) "
  [[ $REPLY =~ ^[Yy]$ ]]
}

backup_existing() {
  echo "→ Backing up existing dotfiles to $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"
  for f in "${DOTFILES[@]}"; do
    [[ -e "$HOME/$f" && ! -L "$HOME/$f" ]] && cp "$HOME/$f" "$BACKUP_DIR/"
  done
}

link_files() {
  echo "→ Symlinking dotfiles from $DOTFILES_DIR"
  for f in "${DOTFILES[@]}"; do
    ln -sf "$DOTFILES_DIR/$f" "$HOME/$f"
  done

  # Cursor user settings
  local cursor_dir="$HOME/Library/Application Support/Cursor/User"
  mkdir -p "$cursor_dir"
  ln -sf "$DOTFILES_DIR/.cursor-settings.json" "$cursor_dir/settings.json"

  # iTerm2 prefs folder (iTerm reads the plist from here)
  mkdir -p "$HOME/.iterm2"
  cp "$DOTFILES_DIR/~.iterm2/com.googlecode.iterm2.plist" "$HOME/.iterm2/"
}

install_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo "→ Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

install_oh_my_zsh() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "→ Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
}

install_zsh_plugins() {
  local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  [[ ! -d "$custom/plugins/zsh-autosuggestions" ]] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$custom/plugins/zsh-autosuggestions"
  [[ ! -d "$custom/plugins/zsh-syntax-highlighting" ]] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom/plugins/zsh-syntax-highlighting"
  [[ ! -d "$custom/plugins/zsh-completions" ]] && \
    git clone https://github.com/zsh-users/zsh-completions "$custom/plugins/zsh-completions"
}

install_brew_bundle() {
  echo "→ Installing from Brewfile (formulae, casks, VS Code/Cursor extensions)"
  brew bundle --file="$DOTFILES_DIR/Brewfile"
}

seed_secrets_file() {
  if [[ ! -f "$HOME/.secrets" ]]; then
    echo "→ Seeding ~/.secrets from template (fill in real values before use)"
    cp "$DOTFILES_DIR/.secrets.example" "$HOME/.secrets"
    chmod 600 "$HOME/.secrets"
  fi
}

configure_iterm() {
  echo "→ Pointing iTerm2 at ~/.iterm2"
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/.iterm2"
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
}

configure_alttab() {
  defaults write com.lwouis.alt-tab-macos windowMinimumHeight -int 200
  defaults write com.lwouis.alt-tab-macos windowMaximumHeight -int 400
  defaults write com.lwouis.alt-tab-macos windowPadding -int 5
  defaults write com.lwouis.alt-tab-macos showOnScreen -string "active"
}

apply_macos() {
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "→ Applying macOS defaults (.macos)"
    bash "$DOTFILES_DIR/.macos"
  fi
}

main() {
  echo "Setting up dotfiles from $DOTFILES_DIR"
  ulimit -n 10240

  confirm "$@" || { echo "Aborted."; exit 1; }

  install_homebrew
  install_brew_bundle
  install_oh_my_zsh
  install_zsh_plugins
  backup_existing
  link_files
  seed_secrets_file
  configure_iterm
  configure_alttab
  apply_macos

  echo "Done. Restart your terminal, then edit ~/.secrets with real tokens."
}

main "$@"
