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
    -y, --yes           answer yes to all yes/no questions")

if [ $# -eq 0 ] ; then
  echo $usage ;
  exit 0 ;
fi;

#TEMP=`getopt -o vdm: --long angular,developer,help,javascript,media,nx,quiet,sysadmin,verbose,yes`

#if [ $? != 0 ] ; then
#  echo "Terminating..." >&2 ;
#  exit 1 ;
#fi

#eval set -- "$TEMP"

ANGULAR=0;
DEVELOPER=0;
HELP=0;
JAVASCRIPT=0;
MEDIA=0;
NX=0;
QUIET=0;
SYSADMIN=0;
VERBOSE=0;
YES=0;

PPA_MODIFIERS=""
APT_MODIFIERS=""
WGET_MODIFIERS=""

LOG_FILE=""

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key=$1
  case "$key" in
    -a | --angular )
        ANGULAR=1;
        DEVELOPER=1;
        JAVASCRIPT=1;
        shift ;;
    -d | --developer )
        DEVELOPER=1;
        shift ;;
    -h | --help )
        echo $usage ;
        HELP=1 ;
        break ;;
    -j | --javascript )
        DEVELOPER=1;
        JAVASCRIPT=1;
        shift ;;
    -m | --media )
        MEDIA=1;
        shift ;;
    --nx )
        DEVELOPER=1;
        JAVASCRIPT=1;
        NX=1;
        shift ;;
    -q | --quiet )
        QUIET=1;
        APT_MODIFIERS="q$APT_MODIFIERS"
        PPA_MODIFIERS="q$PPA_MODIFIERS"
        WGET_MODIFIERS="q$WGET_MODIFIERS"
        LOG_FILE="log`date +%Y%m%d`.backup.txt"
        touch
        LOG_FILE=">>$LOG_FILE"
        shift ;;
    -s | --sysadmin )
        DEVELOPER=1;
        SYSADMIN=1;
        shift ;;
    -v | --verbose )
        VERBOSE=1;
        shift ;;
    -y | --yes )
        YES=1;
        APT_MODIFIERS="y$APT_MODIFIERS"
        PPA_MODIFIERS="y$PPA_MODIFIERS"
        shift ;;
    -- )
        shift ;
        break ;;
    * )
        POSITIONAL+=("$1")
        shift ;;
  esac
done

set -- "${POSITIONAL[@]}"

if [[ $HELP -eq 1 ]] ; then
  echo $usage ;
  exit 0 ;
fi

if [[ $APT_MODIFIERS != "" ]]; then APT_MODIFIERS="-$APT_MODIFIERS"; fi

if [[ $PPA_MODIFIERS != "" ]]; then PPA_MODIFIERS="-$PPA_MODIFIERS"; fi

if [[ $WGET_MODIFIERS != "" ]]; then WGET_MODIFIERS="-$WGET_MODIFIERS"; fi



cd ~/Downloads



if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# First Upgrade"; fi

sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS upgrade \
&& sudo apt $APT_MODIFIERS dist-upgrade

if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# First Upgrade Done"; fi



if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
  echo " ";
  echo "################################";
  echo "#                              #";
  echo "#         Basic setup          #";
  echo "#                              #";
  echo "################################";
fi

if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Enable partners repositories"; fi

sudo sed -i.bak "/^# deb .*partner/ s/^# //" /etc/apt/sources.list

if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Partners repositories enabled"; fi

if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Set basic PPAs up"; fi

sudo add-apt-repository $PPA_MODIFIERS ppa:alessandro-strada/ppa # Google Drive OCamLFuse

sudo add-apt-repository $PPA_MODIFIERS ppa:teejee2008/ppa # Timeshift

sudo add-apt-repository $PPA_MODIFIERS ppa:agornostal/ulauncher # ULauncher

sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS upgrade \
&& sudo apt $APT_MODIFIERS dist-upgrade

if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Basic PPAs set"; fi

if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Installing basic tools"; fi

wget $WGET_MODIFIERS https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

wget $WGET_MODIFIERS https://go.skype.com/skypeforlinux-64.deb

wget $WGET_MODIFIERS https://www.scootersoftware.com/bcompare-4.3.7.25118_amd64.deb

sudo dpkg -i google-chrome-stable_current_amd64.deb

# @TODO: Add code to install my usual Google Chrome extensions

sudo apt $APT_MODIFIERS install chrome-gnome-shell flatpak gdebi \
gnome-software-plugin-flatpak gnome-shell-extensions gnome-tweaks \
google-drive-ocamlfuse laptop-mode-tools libdvd-pkg nautilus-actions \
qt5-style-kvantum qt5-style-kvantum-themes steam synaptic terminator \
thunderbird timeshift transmission ttf-mscorefonts-installer \
ubuntu-restricted-extras ulauncher vlc rar unrar p7zip-full p7zip-rar

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo apt $APT_MODIFIERS install ./skypeforlinux-64.deb
sudo gdebi -n bcompare-4.3.7.25118_amd64.deb

rm bcompare-4.3.7.25118_amd64.deb skypeforlinux-64.deb google-chrome-stable_current_amd64.deb

if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Basic tools installed"; fi

if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Basic security setup"; fi

if [ $(sudo ufw status verbose | grep inactive | wc -l) -eq 1 ]; then sudo ufw enable; fi

sudo dpkg-reconfigure unattended-upgrades

if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Basic security set"; fi

if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Basic configurations"; fi

sudo dpkg-reconfigure libdvd-pkg

sudo apt $APT_MODIFIERS purge ubuntu-web-launchers

gsettings set org.gnome.desktop.interface show-battery-percentage true

echo "export QT_STYLE_OVERRIDE=kvantum" >> ~/.profile

echo 'HISTTIMEFORMAT="%F %T "' >> ~/.bashrc && source ~/.bashrc

if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Basic configurations done"; fi



if [[ $MEDIA -eq 1 ]]; then

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
    echo " ";
    echo "################################";
    echo "#                              #";
    echo "#         Media setup          #";
    echo "#                              #";
    echo "################################";
  fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Installing media tools"; fi

  sudo apt $APT_MODIFIERS install gimp imagemagick inkscape

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Media tools installed"; fi

fi



if [[ $DEVELOPER -eq 1 ]]; then

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
    echo " ";
    echo "################################";
    echo "#                              #";
    echo "#    Basic developer setup     #";
    echo "#                              #";
    echo "################################";
  fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Installing developer's tools"; fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Installing basic tools"; fi

  sudo apt $APT_MODIFIERS install apt-transport-https git \
  software-properties-common wget

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Basic tools installed"; fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Installing Insomnia"; fi

  echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \ | sudo tee -a \
  /etc/apt/sources.list.d/insomnia.list && wget --quiet -O - \
  https://insomnia.rest/keys/debian-public.key.asc \ | sudo apt-key add -

  sudo apt $APT_MODIFIERS install insomnia

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Insomnnia installed"; fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Generating SSH Keyss"; fi

  if [ ! -d ~/.ssh ]; then mkdir ~/.ssh; fi; cd ~/.ssh

  passphrase=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 1024 | head -n 1)
  ssh-keygen -q -t rsa -f id_rsa -N $passphrase;echo $passphrase > pass.txt

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then

    echo "# SSH Keys Generated";

    echo "You'll find your passphrase in ~/.ssh/pass.txt";

  fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Installing VS Code"; fi

  wget $WGET_MODIFIERS https://packages.microsoft.com/keys/microsoft.asc -O- \
  | sudo apt-key $PPA_MODIFIERS add - && sudo add-apt-repository $PPA_MODIFIERS \
  "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

  sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS upgrade \
  && sudo apt $APT_MODIFIERS dist-upgrade

  sudo apt $APT_MODIFIERS install code

  # @TODO: Add code to install my usual VSCode extensions

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# VS Code installed"; fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Installing Telegram"; fi

  sudo add-apt-repository $PPA_MODIFIERS ppa:atareao/telegram

  sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS upgrade \
  && sudo apt $APT_MODIFIERS dist-upgrade

  sudo apt $APT_MODIFIERS install -f telegram

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Telegram installed"; fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Developer's tools installed"; fi

fi



if [[ $SYSADMIN -eq 1 ]]; then

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
    echo " ";
    echo "################################";
    echo "#                              #";
    echo "#  Sysadmin development setup  #";
    echo "#                              #";
    echo "################################";
  fi

fi



if [[ $JAVASCRIPT -eq 1 ]]; then

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
    echo " ";
    echo "################################";
    echo "#                              #";
    echo "# Javascript development setup #";
    echo "#                              #";
    echo "################################";
  fi

fi



if [[ $ANGULAR -eq 1 ]]; then

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
    echo " ";
    echo "################################";
    echo "#                              #";
    echo "#  Angular development setup   #";
    echo "#                              #";
    echo "################################";
  fi

fi



if [[ $NX -eq 1 ]]; then

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
    echo " ";
    echo "################################";
    echo "#                              #";
    echo "#     NX development setup     #";
    echo "#                              #";
    echo "################################";
  fi

fi



if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then

  echo "# A special extra: Installing a Deadpool GRUB theme";

fi

git clone https://github.com/satyakami/grub2-deadpool-theme.git

cd grub2-deadpool-theme

chmod 755 install.sh

sudo ./install.sh

cd ..

rm -r grub2-deadpool-theme

if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Deadpool GRUB theme installed"; fi



if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
  echo " ";
  echo "###############################";
  echo "#                             #";
  echo "#       System clean up       #";
  echo "#                             #";
  echo "###############################";
fi

sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS autoclean \
&& sudo apt $APT_MODIFIERS clean && sudo apt $APT_MODIFIERS autoremove \
&& sudo apt $APT_MODIFIERS update
