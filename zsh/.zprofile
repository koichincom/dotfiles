# Homebrew environment
eval "$(/opt/homebrew/bin/brew shellenv)"

# Python versions (consolidated)
# Note: Order matters - first in PATH has priority
PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:${PATH}"
PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:${PATH}"
export PATH

# Ruby environment
export PATH="/opt/homebrew/opt/rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# Node.js global packages
export PATH="$HOME/.npm-global/bin:$PATH"

# pipx
export PATH="$PATH:$HOME/.local/bin"

# Toolbox App
export PATH="$PATH:/usr/local/bin"
