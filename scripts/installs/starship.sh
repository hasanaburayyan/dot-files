#!/usr/bin/env bash

sh -c "$(curl -fsSL https://starship.rs/install.sh)"
mkdir -p ~/.config
touch ~/.config/starship.toml

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/CascadiaCode.zip
sudo unzip CascadiaCode.zip -d /usr/local/share/fonts
rm CascadiaCode.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/JetBrainsMono.zip
sudo unzip JetBrainsMono.zip -d /usr/local/share/fonts
rm JetBrainsMono.zip
fc-cache -f -v

echo 'eval "$(starship init bash)"' >> ~/.bashrc
