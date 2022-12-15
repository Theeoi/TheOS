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

cwd=$(pwd)
script_dir=$(dirname $0)
script_path="$cwd/$script_dir"
USERHOME="/home/"$(logname)

echo "Running $0 in ${script_dir}..."

### DOWNLOAD RESOURCES ###
echo "Downloading resources to ${script_path}..."
sudo -u $(logname) git clone -q https://github.com/EliverLara/Ant.git $script_path/Ant
sudo -u $(logname) svn export -q https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme/trunk/icons/Kanagawa $script_path/Kanagawa
sudo -u $(logname) git clone -q https://github.com/alvatip/Nordzy-cursors.git $script_path/Nordzy-cursors

sudo -u $(logname) unzip -qq "$script_path/resources/*.zip" -d $script_path/resources/

pamac install lightly-git lightlyshaders-git

pacman -S qt5-websockets python-docopt python-numpy python-pyaudio python-cffi python-websockets
pamac install plasma5-applets-virtual-desktop-bar-git plasma5-applets-window-appmenu plasma5-applets-panon latte-dock

### INITIAL SETUP ###

echo "Installing $0..."

# Ant-Dark
sudo -u $(logname) mkdir -p $USERHOME/.local/share/aurorae/themes
sudo -u $(logname) mkdir -p $USERHOME/.local/share/plasma
mv $script_path/Ant/kde/Dark/aurorae/Ant-Dark $USERHOME/.local/share/aurorae/themes/
mv $script_path/Ant/kde/Dark/color-schemes $USERHOME/.local/share/
mv $script_path/Ant/kde/Dark/icons $USERHOME/.local/share/
mv $script_path/Ant/kde/Dark/konsole/Ant-Dark.colorscheme $USERHOME/.local/share/konsole/
mv $script_path/Ant/kde/Dark/plasma/* $USERHOME/.local/share/plasma/

mv $script_path/Ant/kde/Dark/kvantum $USERHOME/.config/

mv $script_path/Ant/kde/Dark/sddm/Ant-Dark /usr/share/sddm/themes/

# Resources
sudo -u $(logname) mkdir -p $USERHOME/.local/share/fonts
sudo -u $(logname) mkdir -p $USERHOME/.local/share/wallpapers
sudo -u $(logname) mkdir -p $USERHOME/.config/neofetch
mv $script_path/resources/fonts/* $USERHOME/.local/share/fonts/
mv $script_path/resources/wallpapers/* $USERHOME/.local/share/wallpapers/
mv $script_path/resources/color-scheme/Ant-Dark-Mod-Lightly.colors $USERHOME/.local/share/color-schemes/
mv $script_path/resources/plasmoids $USERHOME/.local/share/plasma/
mv $script_path/resources/konsole-profile/ant-dark-konsole-zsh.profile $USERHOME/.local/share/konsole/
mv $script_path/resources/neofetch-config/config.conf $USERHOME/.config/neofetch/

# Kanagawa
mv $script_path/Kanagawa $USERHOME/.local/share/icons/

# Nordzy-cursors
chmod +x $script_path/Nordzy-cursors/install.sh
sudo -u $(logname) source $script_path/Nordzy-cursors/install.sh
sudo -u $(logname) mv $USERHOME/.icons/* $USERHOME/.local/share/icons/
rm -r $USERHOME/.icons

### REMOVE CACHED FILES ###

echo "Removing cached files..."
rm -r $script_path/Ant 2> /dev/null
rm -r $script_path/Kanagawa 2> /dev/null
rm -r $script_path/Nordzy-cursors 2> /dev/null
resource_dirs=$(find "$script_path/resources/"* -type d)
rm -r $resource_dirs 2> /dev/null

### CONFIGURE KDE SETTINGS ###

echo "Configuring KDE settings..."
## Appearance

# Global theme
plasma-apply-lookandfeel -a Ant-Dark
plasma-apply-desktoptheme Ant-Dark

# Application style
kwriteconfig5 --file $USERHOME/.config/kdeglobals \
  --group KDE \
  --key widgetStyle "Lightly"

# Plasma style
kwriteconfig5 --file $USERHOME/.config/kdedefaults/plasmarc \
  --group Theme \
  --key name "Ant-Dark"

# Colours
plasma-apply-colorscheme Ant-Dark-Mod-Lightly

# Window decorations
echo "Window decorations must be set manually to 'Ant-Dark'"

# Fonts
kwriteconfig5 --file $USERHOME/.config/kdeglobals \
  --group General \
  --key font "Roboto,10,-1,5,50,0,0,0,0,0"
kwriteconfig5 --file $USERHOME/.config/kdeglobals \
  --group General \
  --key fixed "FiraCode Nerd Font,10,-1,5,50,0,0,0,0,0"
kwriteconfig5 --file $USERHOME/.config/kdeglobals \
  --group General \
  --key smallestReadableFont "Roboto,8,-1,5,50,0,0,0,0,0"
kwriteconfig5 --file $USERHOME/.config/kdeglobals \
  --group General \
  --key toolBarFont "Roboto,10,-1,5,50,0,0,0,0,0"
kwriteconfig5 --file $USERHOME/.config/kdeglobals \
  --group General \
  --key menuFont "Roboto,10,-1,5,50,0,0,0,0,0"

# Icons
kwriteconfig5 --file $USERHOME/.config/kdeglobals \
  --group Icons \
  --key Theme "Kanagawa"

# Cursors
plasma-apply-cursortheme Nordzy-cursors

# Splash screen
kwriteconfig5 --file $USERHOME/.config/ksplashrc \
  --group KSplash \
  --key Theme "None"

# Wallpapers
kwriteconfig5 --file $USERHOME/.config/kscreenlockerrc \
  --group Greeter \
  --key WallpaperPlugin "org.kde.slideshow"
kwriteconfig5 --file $USERHOME/.config/kscreenlockerrc \
  --group Greeter \
  --key SlidePaths "$USERHOME/.local/share/wallpapers/"

echo "$0 done!"
echo "Set up remaining manual KDE settings through the graphical settings manager."
echo "Reboot computer for changes to take effect."
