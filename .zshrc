# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.

export PATH="$PATH:$HOME/.rvm/bin"
export CLICOLOR=1
export EDITOR='nvim'
export VISUAL='nvim'

set -o vi
alias vi=nvim
alias vim=nvim
alias cdr='cd $(git rev-parse --show-toplevel)'

eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

autoload -Uz compinit
compinit
setopt share_history

eval "$(starship init zsh)"
