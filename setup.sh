#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `setup` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Prompt for everything now
read -r -p "What do you wish to name this computer?: " NAME;
read -r -p "Do you wish to setup this machine for work? [y/N]: " WORK_COMPUTER;

# Setup XCode first
if ! xcode-select -p | grep -q "/Library/Developer/CommandLineTools"; then

  check=$(xcode-select --install 2>&1)

  echo $check

  str="xcode-select: note: install requested for command line developer tools"

  while [[ "$check" == "$str" ]];
  do
    echo "Installing...."
    sleep 3
  done
fi

mkdir -p $HOME/code/samdunne

pushd $HOME/code/samdunne

git clone https://github.com/samdunne/dotfiles.git

pushd dotfiles

/bin/bash sync.sh -f

pushd setup

/bin/bash install.sh

dirs -c