# 🚀 Modern macOS Dotfiles

A curated collection of dotfiles and scripts for setting up a powerful development environment on macOS. Optimized for web development, with a focus on Ruby on Rails, JavaScript/TypeScript, and Docker.

## ✨ Features

- 🛠 Automated setup script
- 🐚 Zsh configuration with Oh My Zsh
- 🎨 Powerlevel10k theme
- 🐳 Docker and development tools
- ⌨️ Cursor (VS Code fork) optimizations
- 🔧 Git configurations and aliases
- 📱 Modern macOS defaults
- 🍺 Homebrew package management

## 🔧 What's Included

- `.zshrc` - Zsh configuration with plugins and optimizations
- `.gitconfig` - Git aliases and configurations
- `.macos` - Sensible macOS defaults
- `.aliases` - Useful command aliases
- `.functions` - Helper shell functions
- `Brewfile` - Essential development tools and apps
- `bootstrap.sh` - Automated setup script

## 📋 Prerequisites

- macOS (tested on Sonoma 14.0+)
- Command Line Tools for Xcode: `xcode-select --install`
- [Homebrew](https://brew.sh)

## 🚀 Quick Start

1. Clone the repository
   ```bash
   git clone https://github.com/adifsgaid/dotfiles.git ~/.dotfiles
   ```

2. Navigate to dotfiles directory
   ```bash
   cd ~/.dotfiles
   ```

3. Run the bootstrap script
   ```bash
   ./bootstrap.sh
   ```

## 📦 What Gets Installed

### Development Tools
- Cursor (VS Code fork)
- iTerm2
- Git
- Node.js
- Python
- Ruby
- Docker
- PostgreSQL
- Redis

### Command Line Tools
- fzf (fuzzy finder)
- ripgrep
- bat
- exa
- tree
- jq


### Applications
- Google Chrome
- Slack
- 1Password
- Raycast
- Figma
- Spotify

## ⚙️ Customization

1. Fork this repository
2. Review the `.macos` file for system preferences
3. Modify the `Brewfile` to add/remove packages
4. Update `.gitconfig` with your details
5. Adjust `.zshrc` plugins and settings

## 🔄 Updates

1. Pull latest changes
   ```bash
   cd ~/.dotfiles
   git pull origin main
   ```

2. Rerun bootstrap
   ```bash
   ./bootstrap.sh
   ```

## 🛠 Manual Steps

Some settings require manual intervention:

1. Open iTerm2 and set your preferred font
2. Configure 1Password
3. Sign in to your GitHub account
4. Import your SSH keys

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔍 Keywords

dotfiles, macos, development, automation, zsh, git, homebrew, iterm2, cursor, docker, web development, ruby on rails, javascript, typescript, productivity

---

Made with ❤️ by [Adif Sgaid](https://github.com/adifsgaid)
