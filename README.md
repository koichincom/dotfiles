# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's Included

- editorconfig - Editor configuration
- git - Git config with aliases and global ignore
- ghostty - Terminal emulator configuration
- nvim - Primary Neovim configuration
- nvim-dev - Development Neovim configuration
- opencode - CLI tool configuration
- zsh - Shell configuration with aliases

## Quick Start

### Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink farm manager

### Installation

```bash
git clone https://github.com/koichincom/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow nvim zsh git ghostty editorconfig opencode
```

### Selective Installation

```bash
# Install only specific configs
stow nvim zsh
```

## License

MIT License - see [LICENSE](LICENSE) file.
