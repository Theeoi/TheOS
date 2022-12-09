# we need neovim with astronvim
sudo pacman -S neovim
git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim nvim

mkdir ~/.config/nvim/lua/user
ln -s ./dotfiles/astronvim-init.lua ~/.config/nvim/lua/user/init.lua
ln -s ./dotfiles/zshrc ~/.config/zsh/.zshrc
ln -s ./dotfiles/gitconfig ~/.config/git/config

# Common dev packages
sudo pacman -S base-devel
sudo pacman -S npm
sudo pacman -S tldr
sudo pacman -S zip unzip
sudo pacman -S github-cli
sudo pacman -S ripgrep lazygit

# LaTeX is needed
sudo pacman -S texlive-most

# Brave as default browser
sudo pacman -S brave-browser

# Emojis
sudo pacman -S noto-fonts-emoji

# Oh-my-zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Nordpass and VPN (AUR enabled)
sudo pamac install nordpass-bin
sudo pamac install nordvpn-bin

sudo usermod -aG nordvpn $USER

# Gimp and Inkscape!
sudo pacman -S gimp inkscape

# XDG superiority
sudo pamac install xdg-ninja
sudo cat "export ZDOTDIR="$HOME"/.config/zsh" > /etc/zsh/zshenv

