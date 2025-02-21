#!/usr/bin/env bash

mkdir "$HOME/dev"
mkdir "$HOME/cc_data"

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
sudo apt install build-essential
sudo apt install cmake
sudo snap install clion --classic

# 5. aws vpn client
wget -qO- https://d20adtppz83p9s.cloudfront.net/GTK/latest/debian-repo/awsvpnclient_public_key.asc | sudo tee /etc/apt/trusted.gpg.d/awsvpnclient_public_key.asc
echo "deb [arch=amd64] https://d20adtppz83p9s.cloudfront.net/GTK/latest/debian-repo ubuntu main" | sudo tee /etc/apt/sources.list.d/aws-vpn-client.list
sudo apt update
sudo apt install awsvpnclient
