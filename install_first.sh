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
sudo apt install neovim tmux meld snapd build-essential ninja-build cmake
sudo snap install clion --classic

# 4.
wget -qO- https://d20adtppz83p9s.cloudfront.net/GTK/latest/debian-repo/awsvpnclient_public_key.asc | sudo tee /etc/apt/trusted.gpg.d/awsvpnclient_public_key.asc
echo "deb [arch=amd64] https://d20adtppz83p9s.cloudfront.net/GTK/latest/debian-repo ubuntu main" | sudo tee /etc/apt/sources.list.d/aws-vpn-client.list
sudo apt update
sudo apt install awsvpnclient

# 5.
cd "$HOME/Downloads" && \
wget -nv https://github.com/catchorg/Catch2/archive/refs/tags/v3.7.1.tar.gz && \
    tar xf v3.7.1.tar.gz && \
    cd Catch2-3.7.1 && \
    sudo cmake -B build/ -G Ninja -DBUILD_TESTING=OFF -DCATCH_INSTALL_DOCS=OFF && \
    sudo cmake --build build/ --target install

# 6.
sudo apt install jq coreutils postgresql-client ca-certificates curl gnupg

# remove docker packages if needed
# for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt remove $pkg; done

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
sudo usermod -aG docker $USER
# reboot so membership will be re-evaluated

# 7.
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
# copy config file to $HOME/.aws folder

# 8.
# Install pdftotext dependencies
sudo apt install libfreetype-dev libfontconfig-dev libjpeg-dev libopenjp2-7-dev
