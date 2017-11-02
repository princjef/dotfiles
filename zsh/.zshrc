# Load antigen
source ~/.zsh/antigen.zsh

# Plugins
antigen use oh-my-zsh

antigen bundle git
antigen bundle docker
antigen bundle docker-compose
antigen bundle node
antigen bundle npm
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

source ~/.zsh/custom/additional.zsh

# Theme
antigen theme $HOME/dotfiles/zsh/theme.zsh

# Let antigen go
antigen apply

# Bindings
bindkey -v # Vim mode
bindkey '^?' backward-delete-char # Fix backspace

# Environment
export KEYTIMEOUT=1
export TERM=xterm-256color

