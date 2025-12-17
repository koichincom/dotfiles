# Environment variables
export EDITOR='nvim'

# Aliases
alias n='nvim .'
alias nvim-test='NVIM_APPNAME=nvim-test nvim'
alias o='opencode'
alias g='git'
alias p='cd ~/Projects'

# Plugins
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
