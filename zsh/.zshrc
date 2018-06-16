# Environment
export ZSH_CACHE_DIR=~/.zsh/
export KEYTIMEOUT=1
export TERM=xterm-256color
path+=($HOME/.bin)
export PATH

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

# Start ssh-agent
eval $(ssh-agent) > /dev/null
