#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
dot_home="profile bashrc bash_logout vimrc vim gitconfig"
dot_config="starship.toml"
source_home="bashrc"

pakages="git wget vim man tree"
dev_pakages="python3.9 python3-pip gcc gdb"
server_pakages="nginx"

git submodule update --init --recursive

echo -e "\e[0;35;7mUPGRADE : System"
echo -e "\n\e[0;1mUpdate\e[90m"
sudo apt -y update
echo -e "\n\e[0;1mUpgrade\e[90m"
sudo apt -y upgrade

echo -e "\e[0;32;7mUPDATE : Dot file"
for f in $dot_home; do
  rm -rf "$HOME/.$f"
  ln -s "$DIR/$f" "$HOME/.$f"
  echo -e "\e[0;1m$f\e[90m"
done

echo -e "\n\e[0;32;7mUPDATE : Dot config"
mkdir -p "$HOME/.config/"
for f in $dot_config; do
  rm -rf "$HOME/.config/$f"
  ln -s "$DIR/$f" "$HOME/.config/$f"
  echo -e "\e[0;1m$f\e[90m"
done

echo -e "\n\n\e[0;33;7mSOURCE : Dot file"
for f in $source_home; do
  source "$HOME/.$f"
  echo -e "\e[0;1m$f\e[90m"
done

echo -ne "\n\n\e[0;34;7mINSTALL : Star Ship\e[0;90m"
mkdir -p ~/.share/bin
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y -b ~/.share/bin/

echo -ne "\n\n\e[0;34;7mINSTALL : User pakages"
for p in $pakages; do
  echo -e "\n\e[0;1m$p\e[90m"
  sudo apt -y install "$p"
done

if [[ "$@" == *"--server"* ]]; then
  echo -ne "\n\n\e[0;34;7mINSTALL : Server pakages"
  for p in $server_pakages; do
    echo -e "\n\e[0;1m$p\e[90m"
    sudo apt -y install "$p"
  done
fi

if [[ "$@" == *"--dev"* ]]; then
  echo -ne "\n\n\e[0;34;7mINSTALL : Dev pakages"
  for p in $dev_pakages; do
    echo -e "\n\e[0;1m$p\e[90m"
    sudo apt -y install "$p"
  done
fi
