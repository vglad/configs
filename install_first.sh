#!/usr/bin/env bash

# 1.
apt-get install open-vm-tools open-vm-tools-desktop

# 2.
cd $HOME/Downloads
dpkg -i google-chrome-stable_current_amd64.deb
apt-get install -f

apt-get install neovim


