#!/bin/bash

# Filesystem setup
mkdir -p ~/.config
mkdir -p ~/.bin
mkdir -p ~/.ssh

# Terminal (Alacritty)
ln -sfn $(pwd)/alacritty ~/.config/alacritty

# ssh
[ -z "$(grep "AddKeysToAgent yes" ~/.ssh/config || "")" ] && echo "AddKeysToAgent yes" >> ~/.ssh/config
chmod 755 ~/.ssh/config

# diff-so-fancy
curl -o ~/.bin/diff-so-fancy https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
chmod +x ~/.bin/diff-so-fancy

##########
# git
##########
if [ $(uname -s) = "Darwin" ]; then
    brew install git
else
    sudo apt-get install -y git
fi
git config --global alias.can 'commit --amend --no-edit'
git config --global alias.pf 'push --force-with-lease'
git config --global alias.pu '!sh -c "git push -u origin $(git rev-parse --abbrev-ref HEAD)"'

git config --global core.pager 'diff-so-fancy | less --tabs=4 -RFX'

git config --global color.ui true

git config --global color.diff-highlight.oldNormal    'red bold'
git config --global color.diff-highlight.oldHighlight 'red bold 52'
git config --global color.diff-highlight.newNormal    'green bold'
git config --global color.diff-highlight.newHighlight 'green bold 22'

git config --global color.diff.meta       'yellow'
git config --global color.diff.frag       'magenta bold'
git config --global color.diff.commit     'yellow bold'
git config --global color.diff.old        'red bold'
git config --global color.diff.new        'green bold'
git config --global color.diff.whitespace 'red reverse'

##########
# zsh
##########

# Install zsh (Linux only)
if [ $(uname -s) = "Darwin" ]; then
    brew install zsh
else
    sudo apt-get install -y zsh
fi

# Zinit

# Install svn
if [ $(uname -s) = "Darwin" ]; then
    brew install subversion
else
    sudo apt-get install -y subversion
fi

bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# For whatever extra stuff we need
mkdir -p ~/.zsh/custom/plugins
touch ~/.zsh/custom/additional.zsh

# Symlink zshrc
ln -sfn $(pwd)/zsh/.zshrc ~/.zshrc
ln -sfn $(pwd)/zsh/.zprofile ~/.zprofile

# Load zsh
chsh -s $(which zsh)

##########
# Node.JS
##########

# Install if not already present
command -v node > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo 'Node not found. Installing...'
    if [ $(uname -s) = "Darwin" ]; then
        brew install node
    else
        curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
        sudo apt install -y nodejs
    fi
else
    echo 'Node is already installed'
fi

# Node version management
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install --lts --reinstall-packages-from=current
nvm use --lts
nvm alias default --lts

##########
# Golang
##########

go get -u github.com/stamblerre/gocode

##########
# Neovim
##########

# Install
if [ $(uname -s) = "Darwin" ]; then
    brew install neovim
    brew install python
else
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y neovim \
        python-dev python-pip \
        python3-dev python3-pip
fi
pip3 install neovim
pip install neovim

# Extra installations for neovim
pip3 install typing # Denite
npm i -g neovim # Node.js client
npm i -g typescript # Nvim-typescript
npm i -g prettier # Neoformat
npm i -g tern # Javascript support

# link to the right place
ln -sfn $(pwd)/nvim ~/.config/nvim

# Set up
nvim -c 'PlugInstall | PlugUpdate'
nvim -c 'UpdateRemotePlugins'

# Use as the default editor for git
git config --global core.editor nvim

#########
# tmux
#########

# Uninstall the old (bundled) version
if [[ $(tmux -V) = *3.3a ]]; then
    echo 'Tmux is already at the correct version'
else
    if [ $(uname -s) = "Darwin" ]; then
        brew install tmux
    else
        command -v tmux > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo 'Found an existing installation of tmux. Removing it...'

            # Debian-based only
            sudo apt remove tmux
        fi

        echo 'Installing tmux'
        sudo apt-get install -y libevent-dev libncurses-dev build-essential
        wget https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz
        tar -xzvf tmux-3.3a.tar.gz
        cd tmux-3.3a
        ./configure && make
        sudo make install
        cd -
    fi

    # Alias for TrueColor support
    alias tmux="env TERM=xterm-256color tmux"

    # Set up Tmux Plugin Manager
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# link things to the right places
ln -sfn $(pwd)/tmux/tmux.conf ~/.tmux.conf
