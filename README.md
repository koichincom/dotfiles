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
stow nvim zsh git  # or whichever packages you want
```

## Requirements

- GNU Stow
- Zsh
- Homebrew (macOS)

### Additional Dependencies

**Zsh plugins:**
```bash
brew install zsh-syntax-highlighting zsh-autosuggestions
```

**OpenCode plugins:**
```bash
cd ~/.config/opencode && npm install
```

## Notes

### Git Configuration

Uses GitHub noreply email. Includes common aliases:
- `st` (status), `co` (checkout), `br` (branch), `cm` (commit -m)
- `lg` (pretty log), `aa` (add --all), `unstage`

### Zsh Configuration

- `.zprofile` - PATH setup (Homebrew, Python, Ruby, Node.js)
- `.zshrc` - Interactive features (aliases, plugins)

All paths use `$HOME` for portability.

## License

MIT License - see [LICENSE](LICENSE) file.
