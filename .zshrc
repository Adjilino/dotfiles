# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Zoxide
eval "$(zoxide init --cmd cd zsh)"

# Starship
eval "$(starship init zsh)"

# Nvim
alias vim="nvim"
alias vi="nvim"

# Zellij
alias zj="zellij"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
