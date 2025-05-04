# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
set -o vi

export PATH="$PATH:$HOME/.rvm/bin"
export CLICOLOR=1
export EDITOR='nvim'
export VISUAL='nvim'
export NVM_DIR="$HOME/.nvm"

autoload -U add-zsh-hook

alias vi=nvim
alias cdgr='cd $(git rev-parse --show-toplevel)'

if [[ "$(uname -s)" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$(uname -s)" == "Linux" ]]; then
fi


## Set up nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
## Set up rvm 
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

#Functions
function load-nvmrc {
  if [ -f ".nvmrc" ]; then
    node_version=$(< .nvmrc)
    if [ ! -z "$node_version" ] && [ "$node_version" != "$(nvm version default)" ]; then
      echo "Using Node version: $node_version"
      nvm use "$node_version"
    fi
  fi
}

function select_env {
  eval $(~/code/tools-and-infrastructure/scripts/developer/select_env_menu.sh)
}


# If we tmux a new pane we instatiate a new shell but in a particular directory starting out, we want to load the nvmrc
load-nvmrc

# If we cd into a new directory, we want to load the nvmrc
add-zsh-hook chpwd load-nvmrc

# If we have the tools-and-infrastructure repo, add the scripts to the path
[[ -d "$HOME/code/tools-and-infrastructure/scripts/developer" ]] && export PATH="$PATH:$HOME/code/tools-and-infrastructure/scripts/developer"

# zsh Auto complete - I think primarily used for ssh, but probably does more
autoload -Uz compinit
compinit

#Carapace autocomplete
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

## Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

eval "$(starship init zsh)"

