# Autoload
autoload -Uz compinit
compinit -i

# Environment
export ZSH_CACHE_DIR=~/.zsh/
export KEYTIMEOUT=1
export TERM=xterm-256color
path+=($HOME/.bin)
export PATH

# History
HISTSIZE=50000          # Number of lines of history to keep in memory
HISTFILE=~/.zsh_history # Location of history file
SAVEHIST=50000          # Number of history entries to save to disk
setopt appendhistory    # Append history to the history file (no overwriting)
setopt sharehistory     # Share history across terminals
setopt incappendhistory # Immediately append to history file, not just on kill

# Load plugins from antibody
source ~/.zsh-plugins.sh

# Load theme
source ~/dotfiles/zsh/theme.zsh

# Load extra plugins
source ~/.zsh/custom/additional.zsh

# Bindings
bindkey -v # Vim mode
bindkey '^?' backward-delete-char # Fix backspace

# Alias
alias rebundle="antibody bundle < ~/dotfiles/zsh/plugins.txt > ~/.zsh-plugins.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
