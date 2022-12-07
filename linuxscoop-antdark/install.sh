#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "$0 is not running as root. Try using sudo."
  exit 2
fi

### DOWNLOAD RESOURCES ###
git clone https://github.com/EliverLara/Ant.git
svn export https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme/trunk/icons/Kanagawa
git clone https://github.com/alvatip/Nordzy-cursors.git

unzip "./resources/*.zip" -d ./resources/

pamac install lighly-git lightlyshaders-git

pacman -S qt5-websockets python-docopt python-numpy python-pyaudio python-cffi python-websockets
pamac install plasma5-applets-virtual-desktop-bar-git plasma5-applets-window-appmenu plasma5-applets-panon latte-dock

### INITIAL SETUP ###

# Resources
mkdir -p $HOME/.local/share/plasma
mv ./resources/fonts/* $HOME/.local/share/fonts/
mv ./resources/wallpapers/* $HOME/.local/share/wallpapers/
mv ./resources/color-scheme/Ant-Dark-Mod-Lightly.colors $HOME/.local/share/color-schemes/
mv ./resources/plasmoids $HOME/.local/share/plasma/
mv ./resources/konsole-profile/ant-dark-konsole-zsh.profile $HOME/.local/share/konsole/
mv ./resources/neofetch-config/config.conf $HOME/.config/neofetch/

# Ant-Dark
mkdir -p $HOME/.local/share/aurorae/themes
mv ./Ant/kde/Dark/aurorae/Ant-Dark $HOME/.local/share/aurorae/themes/
mv ./Ant/kde/Dark/color-schemes $HOME/.local/share/
mv ./Ant/kde/Dark/icons $HOME/.local/share/
mv ./Ant/kde/Dark/konsole/Ant-Dark.colorscheme $HOME/.local/share/konsole/
mv ./Ant/kde/Dark/plasma/* $HOME/.local/share/plasma/

mv ./Ant/kde/Dark/kvantum $HOME/.config/

mv ./Ant/kde/Dark/sddm/Ant-Dark /usr/share/sddm/themes/

# Kanagawa
mv ./Kanagawa $HOME/.local/share/icons/

# Nordzy-cursors
chmod +x ./Nordzy-cursors/install.sh
./Nordzy-cursors/install.sh


