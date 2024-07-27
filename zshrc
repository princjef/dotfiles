# Environment
export ZSH_CACHE_DIR=~/.zsh/
export KEYTIMEOUT=1
export TERM=xterm-256color
path+=($HOME/.bin)
path+=(/usr/local/go/bin)
export PATH

# Misc setup

# ZSH indents the right prompt by 1 by default. Remove that
ZLE_RPROMPT_INDENT=0

# ls coloring (BSD)
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# ls coloring (GNU)
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:
su=30;41:sg=30;46:tw=30;42:ow=30;43"

# History
HISTSIZE=50000          # Number of lines of history to keep in memory
HISTFILE=~/.zsh_history # Location of history file
SAVEHIST=50000          # Number of history entries to save to disk
setopt appendhistory    # Append history to the history file (no overwriting)
setopt sharehistory     # Share history across terminals
setopt incappendhistory # Immediately append to history file, not just on kill

# Load theme
# source ~/dotfiles/zsh/theme.zsh

# Load extra plugins
source ~/.zsh/custom/additional.zsh

# Handle colorings
if $(ls -G . &> /dev/null); then
    alias ls='ls -G'
elif $(ls --color -d . &> /dev/null); then
    alias ls='ls --color=tty'
fi

if [[ -n $LS_COLORS ]]; then
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

######
# ZIM
######

zstyle ':zim:zmodule' use 'degit'

ZIM_CONFIG_FILE=~/.zimrc
ZIM_HOME=~/.zim

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Initialize modules.
source ${ZIM_HOME}/init.zsh

# zsh-history-substring-search

# Bindings
bindkey -v # Vim mode
bindkey '^?' backward-delete-char # Fix backspace

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

eval "$(starship init zsh)"
