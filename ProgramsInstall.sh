#!/bin/bash
set -e

SERVERS=(
  "sysadmin@rkc107-02"
  "sysadmin@rkc107-03"
)

for server in "${SERVERS[@]}"; do
  echo "installing programs on $server..."
  ssh -t "$server" "
    set -e

    echo 'Updating system.....'
    sudo apt update

    echo 'Install packages...'
    sudo apt install -y chromium htop wget curl

    #install google chrome
    echo 'Installing Google Chrome...'
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    rm -f google-chrome-stable_current_amd64.deb

    echo 'Installing Anaconda...'
    wget -q https://repo.anaconda.com/archive/Anaconda3-latest-Linux-x86_64.sh
    bash Anaconda3-latest-Linux-x86_64.sh -b
    ~/anaconda3/bin/conda init bash
    #remove the downloaded file from the computer
    rm -f Anaconda3-latest-Linux-x86_64.sh

    echo 'Done with $server!'
  "
done

echo "All servers have the programs installed now."