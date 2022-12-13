zinit ice svn wait'!0' blockf; zinit snippet OMZ::plugins/docker
zinit ice svn wait'!0' blockf; zinit snippet OMZ::plugins/docker-compose
zinit ice svn wait'!0' blockf; zinit snippet OMZ::plugins/node

zinit load mafredri/zsh-async
zinit ice wait'!0' blockf; zinit load lukechilds/zsh-better-npm-completion
zinit ice wait lucid atload'_zsh_autosuggest_start'; zinit load zsh-users/zsh-autosuggestions
zinit ice wait'!0' blockf; zinit load zsh-users/zsh-completions
zinit ice wait'!0'; zinit load zsh-users/zsh-syntax-highlighting
zinit ice wait'!0'; zinit load zsh-users/zsh-history-substring-search
zinit ice wait'!0'; zinit load wfxr/forgit
