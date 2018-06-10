#!/bin/bash

# Filesystem setup
mkdir -p ~/.config

##########
# git
##########
sudo apt-get install -y git
git config --global alias.can 'commit --amend --no-edit'
git config --global alias.pf 'push --force-with-lease'

##########
# zsh
##########

# Install zsh (Linux only)
sudo apt-get install -y zsh

# Antibody
curl -sL git.io/antibody | sh -s

# For whatever extra stuff we need
mkdir -p ~/.zsh/custom/plugins
touch ~/.zsh/custom/additional.zsh

# Symlink zshrc
ln -sfn $(pwd)/zsh/.zshrc ~/.zshrc

# Create static antibody bundle
antibody bundle < $(pwd)/zsh/plugins.txt > ~/.zsh-plugins.sh

# Load zsh
chsh -s $(which zsh)

##########
# Node.JS
##########

# Install if not already present
command -v node > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo 'Node not found. Installing 8.x...'
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo 'Node is already installed'
fi

# Node version management
sudo npm i -g n
sudo n lts

##########
# Neovim
##########

# Install (Debian-based only)
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt upgrade -y
sudo apt install -y neovim \
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
ln -sfn $(pwd)/nvim ~/.config/nvim

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
        sudo apt remove tmux
    fi

    echo 'Installing tmux'
    sudo apt-get install -y libevent-dev libncurses-dev build-essential
    wget https://github.com/tmux/tmux/releases/download/2.7/tmux-2.7.tar.gz
    tar -xzvf tmux-2.7.tar.gz
    cd tmux-2.7
    ./configure && make
    sudo make install
    cd -

    # Alias for TrueColor support
    alias tmux="env TERM=xterm-256color tmux"

    # Set up Tmux Plugin Manager
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# link things to the right places
ln -sfn $(pwd)/tmux/tmux.conf ~/.tmux.conf
