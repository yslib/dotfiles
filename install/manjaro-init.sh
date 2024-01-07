
sudo pacman-mirrors -GB testing -c China # Change mirrors

# install sogoupinyin
sudo pacman -S fcitx-im    
sudo pacman -S fcitx-configtool
sudo pacman -S fcitx-sogoupinyin

sudo pacman -S google-chrome

# set zsh as default shell
chsh -s /bin/zsh
