#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "$0 is not running as root. Try using sudo."
  exit 2
fi

req_packages="git sh wget pamac"
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

pacman -Syyu                     # Sync and update repositories

### SYSTEM ESSENTIALS ###

pacman -S noto-fonts-emoji      # Enable emojis
pacman -S xclip                 # Improved copy-paste
pacman -S tldr                  # Easy man pages
pacman -S zip unzip             # zip extraction
pacman -S timeshift             # System backup
pacman -S base-devel            # Basic development
pamac install xdg-ninja         # Keep a clean $HOME

# zsh terminal with Oh-my-zsh
# sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
pamac install oh-my-zsh-git
cat "export ZDOTDIR=$USERHOME/.config/zsh" > /etc/zsh/zshenv
mkdir -p $USERHOME/.config/zsh
ln -s $script_path/dotfiles/zshrc $USERHOME/.config/zsh/.zshrc

### DEVELOPMENT ###

# Git
pacman -S github-cli lazygit
mkdir -p $USERHOME/.config/git
ln -s $script_path/dotfiles/gitconfig $USERHOME/.config/git/config

# Neovim
pacman -S neovim
git clone https://github.com/AstroNvim/AstroNvim $USERHOME/.config/nvim nvim
mkdir -p $USERHOME/.config/nvim/lua/user
ln -s $script_path/dotfiles/astronvim-init.lua $USERHOME/.config/nvim/lua/user/init.lua

# Common dev packages
pacman -S npm
pacman -S ripgrep
pacman -S svn

### PROGRAMS ###

pacman -S texlive-most          # LaTeX <3
pacman -S brave-browser         # Brave as default browser
pacman -S thunderbird           # Email
pacman -S gimp inkscape         # Graphical work

# Nord-suite
pamac install nordpass-bin
pamac install nordvpn-bin
systemctl enable --now nordvpnd
gpasswd -a $(logname) nordvpnd

### DE INSTALLER ###

EVERYTHING=$'All packages (!)'
SKIP_DE=$'Skip DE installation'
MENU_OPT=( "$EVERYTHING" "$SKIP_DE" )

echo "Select a DE package to install:"
AVAILABLE_DE=( "linuxscoop-antdark" )

select choice in "${AVAILABLE_DE[@]}" "${MENU_OPT[@]}";
do
  case $choice in
    linuxscoop-antdark)
      source $script_path/$choice/install.sh
      break
      ;;
    'All packages (!)')
      for de in $AVAILABLE_DE; do
        source $script_path/$de/install.sh
      done
      break
      ;;
    'Skip DE installation')
      echo "Skipping DE installation."
      break
      ;;
    *)
      echo "Invalid DE choice."
      ;;
  esac
done
