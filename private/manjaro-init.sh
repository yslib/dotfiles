
sudo pacman-mirrors -GB testing -c China # Chain mirrors

# install sogoupinyin
sudo pacman -S fcitx-im    
sudo pacman -S fcitx-configtool
sudo pacman -S fcitx-sogoupinyin

sudo pacman -S google-chrome

# set zsh as default shell
chsh -s /bin/zsh

# install zsh
# via curl
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# via wget
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# install zsh plugin
  # zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
  # zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting


# Clash install
# gotop
# tmux



