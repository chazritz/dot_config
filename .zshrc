export PATH="$PATH:$HOME/.rvm/bin"
export CLICOLOR=1
export EDITOR='nvim'
export VISUAL='nvim'
export NVM_DIR="$HOME/.nvm"

# Command line vi editing mode - much nicer than arrow keys
set -o vi

# You need this for nvmrc directory changes, but probably other things?
autoload -U add-zsh-hook

#alias to change into the root of the git repository
alias cdgr='cd $(git rev-parse --show-toplevel)'
alias vi=nvim

#This file is shared between linux and macOS - on macOS we want brew commands
export OS=$(uname -s)
if [[ "${OS}" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="/opt/homebrew/bin:$PATH"
  #GNU LS ( from brew install coreutils ) - this is needed for a working LS_COLORS, which is used by vivid for ls theming
  alias ls='gls --color=auto --group-directories-first'
else
  alias ls='ls --color=auto --group-directories-first'
fi

# Set up LS_COLORS for theming
export LS_COLORS="$(vivid generate catppuccin-latte)"

## Set up nvm and rvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

#Functions
# This function loads the nvmrc file if it exists in the current directory
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
  # select_env_menu.sh 
  eval $(~/code/tools-and-infrastructure/scripts/developer/select_env_menu.sh)
}

# If we tmux split pane, or open a shell with CWD preserved, we'd like to be using the correct node version
load-nvmrc

# If we cd into a new directory, we want to load the nvmrc
add-zsh-hook chpwd load-nvmrc

# If we have the tools-and-infrastructure repo, add the scripts to the path
[[ -d "$HOME/code/tools-and-infrastructure/scripts/developer" ]] && export PATH="$PATH:$HOME/code/tools-and-infrastructure/scripts/developer"

# zsh Auto complete - needed by carapace ( for the curious, compinit is a zsh internal thing, not a package ) 
autoload -Uz compinit
compinit

#Carapace autocomplete does some heavy autocomplete suggestions
#Its completion list - https://carapace-sh.github.io/carapace-bin/completers.html
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

## Set up fzf key bindings and fuzzy completion
## Ctrl-R to search history, Ctrl-T to search files ( probably does other things as well ) 
source <(fzf --zsh)

#Starship = pretty command prompt - uses ~/.config/starship.toml for configuration
eval "$(starship init zsh)"

