#!/bin/bash

usage=$("after-install 1.0.0
Usage: after-install [{-h | --help}] [{-a | --angular}] [{-d | --developer}]
                        [{-j | --javascript}] [{-m | --media}] [--nx]
                        [{-q | --quiet}] [{-s | --sysadmin}] [{-v | --verbose}]
                        [{-y | --yes}]

after-install is a script to set up a base environment after a clean Ubuntu
installation.

where:
    -a, --angular       sets up an angular development environment
    -d, --developer     sets up a basic development environment
    -h, --help          show this help text
    -j, --javascript    sets up a javascript development environment
    -m, --media         sets up a media workspace
    --nx                sets up a nx development environment
    -q, --quiet         executes the script without any message
    -s, --sysadmin      sets up a sysadmin environment
    -v, --verbose       print all instructions and comments
    -y, --yes           answer yes to all yes/no questions
     ")

if [ $# -eq 0 ]; then
  echo $usage ;
  exit 0 ;
fi;

TEMP=`getopt -o vdm: --long angular,developer,help,javascript,media,nx,quiet,sysadmin,verbose,yes`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

ANGULAR=false
DEVELOPER=false
HELP=false
JAVASCRIPT=false
MEDIA=false
NX=false
QUIET=false
SYSADMIN=false
VERBOSE=false
YES=false

PPA_MODIFIERS=""
APT_MODIFIERS=""
WGET_MODIFIERS=""

while true; do
  case "$1" in
    -a | --angular ) ANGULAR=true; shift ;;
    -d | --developer ) DEVELOPER=true; shift ;;
    -h | --help )
        echo $usage ; HELP=true; shift ; break ;;
    -j | --javascript ) JAVASCRIPT=true; shift ;;
    -m | --media ) MEDIA=true; shift ;;
    --nx ) NX=true; shift ;;
    -q | --quiet )
        QUIET=true;
        APT_MODIFIERS="q$APT_MODIFIERS"
        PPA_MODIFIERS="q$PPA_MODIFIERS"
        WGET_MODIFIERS="q$WGET_MODIFIERS"
        shift ;;
    -s | --sysadmin ) SYSADMIN=true; shift ;;
    -v | --verbose ) VERBOSE=true; shift ;;
    -y | --yes )
        YES=true;
        APT_MODIFIERS="y$APT_MODIFIERS"
        PPA_MODIFIERS="y$PPA_MODIFIERS"
        shift ;;
    -- ) shift ; break ;;
    * ) break ;;
  esac
done

if [ $HELP ]; then
  exit 1 ;
fi;

if [ $APT_MODIFIERS !== "" ]; then APT_MODIFIERS="-$APT_MODIFIERS"; fi
if [ $PPA_MODIFIERS !== "" ]; then PPA_MODIFIERS="-$PPA_MODIFIERS"; fi
if [ $WGET_MODIFIERS !== "" ]; then WGET_MODIFIERS="-$WGET_MODIFIERS"; fi

cd ~/Downloads

sudo add-apt-repository $PPA_MODIFIERS ppa:alessandro-strada/ppa
sudo add-apt-repository $PPA_MODIFIERS ppa:teejee2008/ppa
sudo add-apt-repository $PPA_MODIFIERS ppa:agornostal/ulauncher
wget $WGET_MODIFIERS https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget $WGET_MODIFIERS https://go.skype.com/skypeforlinux-64.deb

if [ $VERBOSE && !$QUIET ]; then echo "First Upgrade"; fi
sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS upgrade && sudo apt $APT_MODIFIERS dist-upgrade
if [ $VERBOSE && !$QUIET ]; then echo "First Upgrade Done"; fi

echo "Installing Basic Tools"
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt $APT_MODIFIERS install gdebi gimp chrome-gnome-shell gnome-shell-extensions gnome-tweaks google-drive-ocamlfuse imagemagick inkscape laptop-mode-tools libdvd-pkg nautilus-actions qt5-style-kvantum qt5-style-kvantum-themes steam synaptic terminator timeshift ubuntu-restricted-extras ulauncher vlc rar unrar p7zip-full p7zip-rar
sudo apt $APT_MODIFIERS install ./skypeforlinux-64.deb
sudo dpkg-reconfigure libdvd-pkg
sudo dpkg-reconfigure unattended-upgrades
sudo apt $APT_MODIFIERS purge ubuntu-web-launchers
gsettings set org.gnome.desktop.interface show-battery-percentage true
echo "export QT_STYLE_OVERRIDE=kvantum" >> ~/.profile
echo 'HISTTIMEFORMAT="%F %T "' >> ~/.bashrc && source ~/.bashrc
echo "Basic Tools Installed"

echo "Installing Dev Tools"
sudo apt $APT_MODIFIERS install apt-transport-https git software-properties-common wget
wget $WGET_MODIFIERS https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key $PPA_MODIFIERS add -
sudo add-apt-repository $PPA_MODIFIERS "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS upgrade && sudo apt $APT_MODIFIERS dist-upgrade
sudo apt $APT_MODIFIERS install code

sudo add-apt-repository $PPA_MODIFIERS ppa:atareao/telegram &&\
sudo apt $APT_MODIFIERS update &&\
sudo apt $APT_MODIFIERS install -f telegram
echo "Dev Tools Installed"

echo "Installing Beyond Compare"
wget $WGET_MODIFIERS https://www.scootersoftware.com/bcompare-4.3.7.25118_amd64.deb
sudo gdebi -n bcompare-4.3.7.25118_amd64.deb
echo "Beyond Compare Installed"

git clone https://github.com/satyakami/grub2-deadpool-theme.git
cd grub2-deadpool-theme
chmod 755 install.sh
sudo ./install.sh
cd ..
rm -r grub2-deadpool-theme

echo "Generating SSH Keys"
if [ ! -d ~/.ssh ]; then mkdir ~/.ssh; fi; cd ~/.ssh
passphrase=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 1024 | head -n 1); ssh-keygen -q -t rsa -f id_rsa -N $passphrase;echo $passphrase > pass.txt
echo "SSH Keys Generated"

echo "Cleaning the System"
rm bcompare-4.3.7.25118_amd64.deb skypeforlinux-64.deb google-chrome-stable_current_amd64.deb
sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS autoremove && sudo apt $APT_MODIFIERS autoclean && sudo apt $APT_MODIFIERS update
echo "System Cleaned"
