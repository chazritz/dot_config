# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.

export PATH="$PATH:$HOME/.rvm/bin"
export CLICOLOR=1
export EDITOR='nvim'
export VISUAL='nvim'
autoload -U add-zsh-hook

set -o vi
alias vi=nvim
alias vim=nvim
alias cdgr='cd $(git rev-parse --show-toplevel)'

if [[ "$(uname -s)" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$(uname -s)" == "Linux" ]]; then
else
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

autoload -Uz compinit
compinit
select_env() {
  eval $(~/code/tools-and-infrastructure/scripts/developer/select_env_menu.sh)
}

function load-nvmrc {
  if [ -f ".nvmrc" ]; then
    node_version=$(< .nvmrc)
    if [ ! -z "$node_version" ] && [ "$node_version" != "$(nvm version default)" ]; then
      echo "Using Node version: $node_version"
      nvm use "$node_version"
    fi
  fi
}
add-zsh-hook chpwd load-nvmrc
#setopt share_history

## Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

eval "$(starship init zsh)"
