#!/usr/bin/env zsh
ulimit -n 10240

DOTFILES_DIR=$(pwd)
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Install Oh My Zsh if not already installed
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
}

# Install Powerlevel10k if not already installed
install_powerlevel10k() {
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        echo "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    fi
}

# Install ZSH plugins if not already installed
install_plugins() {
    # Auto-suggestions
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        echo "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi

    # Syntax highlighting
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        echo "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
}

backup_existing() {
    echo "Creating backup directory at $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    for file in .zshrc .aliases .functions .gitconfig .p10k.zsh .vimrc .bashrc .bash_profile .macos; do
        if [ -f "$HOME/$file" ]; then
            echo "Backing up existing $file"
            cp "$HOME/$file" "$BACKUP_DIR/"
        fi
    done
}

link_files() {
    echo "Symlinking dotfiles..."
    
    # Create symlinks for each dotfile
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/.aliases" "$HOME/.aliases"
    ln -sf "$DOTFILES_DIR/.functions" "$HOME/.functions"
    ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
    ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
    ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
    ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
    ln -sf "$DOTFILES_DIR/.bash_profile" "$HOME/.bash_profile"
    ln -sf "$DOTFILES_DIR/.macos" "$HOME/.macos"

    # Link Cursor settings
    CURSOR_SETTINGS_DIR="$HOME/Library/Application Support/Cursor/User"
    mkdir -p "$CURSOR_SETTINGS_DIR"
    ln -sf "$DOTFILES_DIR/.cursor-settings.json" "$CURSOR_SETTINGS_DIR/settings.json"
}

setup_macos() {
    echo "Configuring macOS settings..."
    if [[ "$(uname)" == "Darwin" ]]; then
        source "$HOME/.macos"
    else
        echo "Skipping macOS configuration (not on macOS)"
    fi
}

install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

install_cursor_extensions() {
    echo "Installing Cursor extensions..."
    
    # Check if Cursor is installed
    if [ ! -d "/Applications/Cursor.app" ]; then
        echo "Cursor is not installed. Please install Cursor first."
        return 1
    fi

    CURSOR_CMD="/Applications/Cursor.app/Contents/MacOS/Cursor"
    
    extensions=(
        "vscodevim.vim"
        "rebornix.ruby"
        "castwide.solargraph"
        "kaiwood.endwise"
        "dbaeumer.vscode-eslint"
        "esbenp.prettier-vscode"
        "ms-azuretools.vscode-docker"
        "bradlc.vscode-tailwindcss"
        "formulahendry.auto-rename-tag"
        "streetsidesoftware.code-spell-checker"
        "eamodio.gitlens"
        "github.copilot"
        "github.copilot-chat"
        "pkief.material-icon-theme"
    )
    
    for extension in "${extensions[@]}"; do
        "$CURSOR_CMD" --install-extension "$extension"
    done
}

main() {
    echo "Setting up your dotfiles..."
    
    # Increase file descriptor limit
    ulimit -n 10240
    
    # Confirm before proceeding
    if [ "$1" != "--force" ] && [ "$1" != "-f" ]; then
        read "REPLY?This may overwrite existing files in your home directory. Are you sure? (y/n) "
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborting..."
            exit 1
        fi
    fi

    # Check for Homebrew
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Pull latest changes
    git pull origin master

    # Create backups
    backup_existing

    # Install Oh My Zsh and plugins
    install_oh_my_zsh
    install_powerlevel10k
    install_plugins

    # Link dotfiles
    link_files

    # Install Cursor extensions if Cursor is installed
    if [ -d "/Applications/Cursor.app" ]; then
        install_cursor_extensions
    else
        echo "Cursor is not installed. Skipping extension installation."
    fi

    # Apply macOS settings
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "Applying macOS settings..."
        source "$HOME/.macos"
    fi

    # Source the new configuration
    echo "Sourcing new configuration..."
    exec zsh

    echo "Done! 🎉"
    echo "Please restart your terminal for all changes to take effect."
}

main "$@"