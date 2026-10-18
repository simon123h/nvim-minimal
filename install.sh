#!/bin/bash

# check for active network connection
if ! ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  echo "Error: no network connection."
  exit 2
fi

# if "-q" was passed --> quiet mode
if [ "$1" = "-q" ]; then
  quiet_wget=-q
fi

# install NERD font
# mkdir -p ~/.local/share/fonts
# (cd ~/.local/share/fonts &&
    # wget $quiet_wget -nc -O "Droid Sans Mono Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf)

# delete existing nvim configs and caches
# rm -rf ~/.cache/nvim
# rm -rf ~/.local/share/nvim
# rm -rf ~/.local/state/nvim
# rm -rf "$(pwd -P)/plugin"

# install the config
mkdir -p ~/.config
rm -rf ~/.config/nvim
ln -sTfv "$(pwd -P)" "$HOME/.config/nvim"

# install in background
# nvim --headless "+Lazy! sync" +qa
