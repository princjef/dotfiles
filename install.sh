#!/bin/bash

##########
# zsh
##########

# Install zsh (Linux only)
sudo apt-get install -y zsh git

# Oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Set vi mode
echo 'bindkey -v' >> ~/.zshrc
echo "bindkey '^?' backward-delete-char" >> ~/.zshrc

echo '
function zle-line-init zle-keymap-select {
    VIM_NORMAL="%{$fg_bold[black]%} %{$bg[yellow]%} NORMAL %{$reset_color%}"
    VIM_INSERT="%{$fg_bold[black]%} %{$bg[cyan]%} INSERT %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1
' >> ~/.zshrc

##########
# Node.JS
##########

# Install if not already present
command -v node > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo 'Node not found. Installing 8.x...'
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo 'Node is already installed'
fi

# Node version management
sudo npm i -g n
sudo n stable

##########
# Neovim
##########

# Install (Debian-based only)
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y neovim \
    python-dev python-pip \
    python3-dev python3-pip
pip3 install neovim

# Extra installations for neovim
pip3 install typing # Denite
sudo npm i -g typescript # Nvim-typescript
sudo npm i -g typescript-formatter # Neoformat
sudo npm i -g tern # Javascript support

# Set up
nvim -c 'PlugInstall | PlugUpdate'
nvim -c 'UpdateRemotePlugins'

# link to the right place
ln -s $(pwd)/nvim ~/.config/nvim

# Use as the default editor for git
git config --global core.editor nvim

#########
# tmux
#########

# Uninstall the old (bundled) version
if [[ $(tmux -V) = *2.6 ]]; then
    echo 'Tmux is already at the correct version'
else
    command -v tmux > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo 'Found an existing installation of tmux. Removing it...'

        # Debian-based only
        sudo apt-get remove tmux
    fi

    echo 'Installing tmux'
    sudo apt-get install -y libevent-dev libncurses-dev build-essential
    wget https://github.com/tmux/tmux/releases/download/2.6/tmux-2.6.tar.gz
    tar -xzvf tmux-2.6.tar.gz
    cd tmux-2.6
    ./configure && make
    sudo make install
    cd -

    # Alias for TrueColor support
    alias tmux="env TERM=xterm-256color tmux"

    # Set up Tmux Plugin Manager
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# link things to the right places
ln -s $(pwd)/tmux/tmux.conf ~/.tmux.conf
