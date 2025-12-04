# Dotfiles

Personal configuration files managed with GNU Stow.

## Contents

- **nvim** - Neovim configuration
- **nvim-dev** - Development Neovim configuration
- **ghostty** - Ghostty terminal emulator configuration
- **editorconfig** - Global editor settings
- **opencode** - OpenCode/Claude configuration
- **git** - Git configuration with aliases and global ignore patterns
- **zsh** - Zsh shell configuration (interactive and login)

## Requirements

- GNU Stow
- Zsh
- Homebrew (for macOS)

## Installation

Clone this repository to your home directory:

```bash
git clone <repository-url> ~/.dotfiles
cd ~/.dotfiles
```

Install all packages:

```bash
stow nvim nvim-dev ghostty editorconfig opencode git zsh
```

Or install packages individually:

```bash
stow nvim
stow zsh
stow git
```

## Notes

### Git Configuration

The `.gitconfig` uses a GitHub noreply email address. The configuration includes:
- Common git aliases (st, co, br, cm, lg, etc.)
- Global gitignore patterns for macOS, Node.js, Python, and common editors

### Zsh Configuration

- `.zprofile` - Login shell configuration (PATH setup)
- `.zshrc` - Interactive shell configuration (aliases, plugins)

Requires zsh-syntax-highlighting and zsh-autosuggestions plugins:

```bash
brew install zsh-syntax-highlighting zsh-autosuggestions
```

### OpenCode Configuration

The OpenCode package includes plugin configuration. Install plugins after stowing:

```bash
cd ~/.config/opencode
npm install
```

## Uninstalling

Remove symlinks for specific packages:

```bash
cd ~/.dotfiles
stow -D nvim
stow -D zsh
```

## License

Personal configuration files - use at your own discretion.
