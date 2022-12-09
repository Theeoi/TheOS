#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "$0 is not running as root. Try using sudo."
  exit 2
fi

req_packages="git svn unzip"
pacman_check=$(pacman -Q $req_packages 2>&1)
if [[ $pacman_check = *"was not found"* ]]; then
  echo "You do not have all required packages to run $0."
  echo "Please make sure you have these packages installed:"
  echo $req_packages
  exit 2
fi

echo "Running $0..."

cwd=$(pwd)
script_dir=$(dirname $0)
script_path="$cwd/$script_dir"

### DOWNLOAD RESOURCES ###
echo "Downloading resources..."
git clone -q https://github.com/EliverLara/Ant.git $script_path/Ant
svn export -q https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme/trunk/icons/Kanagawa $script_path/Kanagawa
git clone -q https://github.com/alvatip/Nordzy-cursors.git $script_path/Nordzy-cursors

unzip -qq "$script_path/resources/*.zip" -d $script_path/resources/

pamac install --no-confirm lighly-git lightlyshaders-git

pacman -Sq --noconfirm qt5-websockets python-docopt python-numpy python-pyaudio python-cffi python-websockets
pamac install --no-confirm mplasma5-applets-virtual-desktop-bar-git plasma5-applets-window-appmenu plasma5-applets-panon latte-dock

### INITIAL SETUP ###

echo "Installing $0..."

# Resources
mkdir -p $HOME/.local/share/plasma
mv $script_path/resources/fonts/* $HOME/.local/share/fonts/
mv $script_path/resources/wallpapers/* $HOME/.local/share/wallpapers/
mv $script_path/resources/color-scheme/Ant-Dark-Mod-Lightly.colors $HOME/.local/share/color-schemes/
mv $script_path/resources/plasmoids $HOME/.local/share/plasma/
mv $script_path/resources/konsole-profile/ant-dark-konsole-zsh.profile $HOME/.local/share/konsole/
mv $script_path/resources/neofetch-config/config.conf $HOME/.config/neofetch/

# Ant-Dark
mkdir -p $HOME/.local/share/aurorae/themes
mv $script_path/Ant/kde/Dark/aurorae/Ant-Dark $HOME/.local/share/aurorae/themes/
mv $script_path/Ant/kde/Dark/color-schemes $HOME/.local/share/
mv $script_path/Ant/kde/Dark/icons $HOME/.local/share/
mv $script_path/Ant/kde/Dark/konsole/Ant-Dark.colorscheme $HOME/.local/share/konsole/
mv $script_path/Ant/kde/Dark/plasma/* $HOME/.local/share/plasma/

mv $script_path/Ant/kde/Dark/kvantum $HOME/.config/

mv $script_path/Ant/kde/Dark/sddm/Ant-Dark /usr/share/sddm/themes/

# Kanagawa
mv $script_path/Kanagawa $HOME/.local/share/icons/

# Nordzy-cursors
chmod +x $script_path/Nordzy-cursors/install.sh
source $script_path/Nordzy-cursors/install.sh

### REMOVE CACHED FILES ###

echo "Removing cached files..."
rm -r $script_path/Ant 2> /dev/null
rm -r $script_path/Kanagawa 2> /dev/null
rm -r $script_path/Nordzy-cursors 2> /dev/null
resource_dirs=$(find "$script_path/resources/"* -type d)
rm -r $resource_dirs 2> /dev/null

echo "$0 done!"
echo "Set up your new KDE DE through the graphical settings manager."
