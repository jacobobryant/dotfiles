#!/bin/bash
mkdir -p ~/.config/nvim
ln -sf $PWD/init.vim ~/.config/nvim/
ln -sf $PWD/coc-settings.json ~/.config/nvim/
echo "source $PWD/bashrc" >> ~/.bashrc
ln -sf $PWD/dircolors ~/.dircolors
ln -sf $PWD/gitconfig ~/.gitconfig
ln -sf $PWD/AGENTS.md ~/AGENTS.md

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

sudo apt install silversearcher-ag unzip

curl -fsSL https://raw.githubusercontent.com/clojure-lsp/clojure-lsp/master/install -o /tmp/clojure-lsp-install.sh
sudo bash /tmp/clojure-lsp-install.sh
rm -f /tmp/clojure-lsp-install.sh

curl -sL https://deb.nodesource.com/setup_25.x -o /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt install nodejs
