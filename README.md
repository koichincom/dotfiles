# Dotfiles

Personal configuration files managed with GNU Stow.

## Packages

- **nvim** - Neovim configuration
- **nvim-dev** - Development Neovim configuration  
- **ghostty** - Ghostty terminal emulator
- **editorconfig** - Global editor settings
- **opencode** - OpenCode/Claude CLI tool
- **git** - Git with aliases and global ignore patterns
- **zsh** - Zsh shell (`.zprofile` for PATH, `.zshrc` for interactive)

## Quick Start

```bash
git clone https://github.com/koichincom/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow nvim zsh git
```

## Requirements

- GNU Stow
- Zsh
- Homebrew (macOS)

### Dependencies

```bash
brew install zsh-syntax-highlighting zsh-autosuggestions
cd ~/.config/opencode && npm install
```

## License

MIT License - see [LICENSE](LICENSE) file.