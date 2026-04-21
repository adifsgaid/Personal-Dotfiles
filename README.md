# dotfiles

My Mac. If I wipe it or buy a new one, `bootstrap.sh` rebuilds it.

## What's in here

| File | What it does |
|------|--------------|
| `.zshrc` | zsh + oh-my-zsh, rbenv/nvm/pyenv/pnpm/cargo/nix/direnv, fzf helpers |
| `.aliases` | Git / Docker / Node shortcuts + Yoojo, Cloud 66, PromptZone, Adreel helpers |
| `.bashrc`, `.bash_profile` | Keep bash usable when something drops me into it |
| `.gitconfig` | Git identity and aliases |
| `.vimrc` | Plain vim for quick edits |
| `.macos` | `defaults write ...` for a couple hundred macOS tweaks |
| `.cursor-settings.json` | Cursor/VS Code settings |
| `Brewfile` | Every formula, cask, and Cursor extension I have installed |
| `.secrets.example` | Template for `~/.secrets` — real tokens live there, never here |
| `bootstrap.sh` | Installs everything and symlinks the dotfiles |

## Setup on a fresh Mac

```bash
xcode-select --install
git clone git@github.com:adifsgaid/Personal-Dotfiles.git ~/Personal-Dotfiles
cd ~/Personal-Dotfiles
./bootstrap.sh
```

`bootstrap.sh` will:

1. Install Homebrew
2. Run `brew bundle` (formulae, casks, Cursor/VS Code extensions)
3. Install oh-my-zsh + zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions
4. Back up whatever dotfiles already exist in `$HOME` to `~/.dotfiles_backup/<timestamp>/`
5. Symlink every dotfile from this repo into `$HOME`
6. Copy `.secrets.example` to `~/.secrets` (0600) if it's not there yet
7. Point iTerm2 at `~/.iterm2/` and apply AltTab defaults
8. Source `.macos` to apply all the system tweaks

Re-running it is safe — backups are timestamped and symlinks are replaced in place.

## Secrets

Anything that should never hit git lives in `~/.secrets`. It's sourced by `.zshrc` and `.bashrc` on shell startup. `.gitignore` blocks it.

On a new machine, after `bootstrap.sh` has seeded the template:

```bash
$EDITOR ~/.secrets
```

Fill in Railway tokens, MCP tokens, Stripe webhook secret, PromptZone Postgres creds. Aliases and functions in `.aliases` / `.zshrc` read from these env vars — don't paste real values into either file.

## Updating

After installing or removing anything:

```bash
brew bundle dump --force --file=~/Personal-Dotfiles/Brewfile
```

That re-captures formulae/casks/extensions. Commit and push.

For dotfile edits, edit the file in this repo directly — the symlink means the shell picks up changes immediately.

## Manual steps that don't fit into a script

- Sign in to 1Password, Raycast, Slack, Telegram, WhatsApp
- Import SSH keys into `~/.ssh/`
- Log into `gh auth login`
- Configure iTerm2 profile/font once (Fira Code or Hack Nerd Font)
- Set up Cursor extensions that need individual auth (Claude Code, ChatGPT, etc.)

## Notes

- Docker is installed as a cask for compatibility but I run containers through OrbStack (also in `Brewfile`).
- `ZSH_THEME` is `robbyrussell`, not powerlevel10k. The instant-prompt guard at the top of `.zshrc` is harmless when p10k isn't installed.
- The `~.iterm2/` folder with the weird name is intentional — it ships the iTerm2 plist so the bootstrap can drop it into `~/.iterm2/` on a fresh machine.
