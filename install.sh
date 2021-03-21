#!/bin/bash

cd ~/Downloads

echo "First Upgrade"
sudo apt -q update && sudo apt -qy upgrade
echo "First Upgrade Done"

echo "Installing Basic Tools"
sudo apt -qy install gdebi gimp git imagemagick inkscape nautilus-actions terminator virtualbox vlc
echo "Basic Tools Installed"

echo "Installing Skype"
wget https://go.skype.com/skypeforlinux-64.deb
sudo apt -qy install ./skypeforlinux-64.deb
echo "Skype Installed"

echo "Installing Beyond Compare"
wget https://www.scootersoftware.com/bcompare-4.3.7.25118_amd64.deb
sudo gdebi -n bcompare-4.3.7.25118_amd64.deb
echo "Beyond Compare Installed"

echo "Generating SSH Keys"
if [ ! -d ~/.ssh ]; then mkdir ~/.ssh; fi; cd ~/.ssh
passphrase=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 1024 | head -n 1); ssh-keygen -q -t rsa -f id_rsa -N $passphrase;echo $passphrase > pass.txt
echo "SSH Keys Generated"

echo "Cleaning the System"
rm bcompare-4.3.7.25118_amd64.deb skypeforlinux-64.deb
sudo apt -q update && sudo apt -qy autoremove && sudo apt -qy autoclean && sudo apt -q update
echo "System Cleaned"
