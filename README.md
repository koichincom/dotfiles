# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

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

## License

MIT License - see [LICENSE](LICENSE) file.