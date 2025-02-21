#!/usr/bin/env bash

# 1.
sudo apt install open-vm-tools open-vm-tools-desktop

# 2.
cd "$HOME/Downloads" && {
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
    sudo dpkg -i google-chrome-stable_current_amd64.deb &&
    sudo apt install -f
}

# 3.
sudo apt install neovim
sudo apt install tmux
sudo apt install meld

# 4.
sudo apt install snapd
sudo snap install clion --classic
