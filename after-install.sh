#!/bin/bash

usage=$("after-install 1.0.0
Usage: after-install [{-h | --help}] [{-a | --angular}] [{-d | --developer}]
                  [{-j | --javascript}] [{-p | --php}] [{-m | --media}]
                  [--nx] [{-q | --quiet}] [{-s | --sysadmin}] [{-v | --verbose}]
                  [{-w | --wordpress}] [{-y | --yes}]

after-install is a script to set up a base environment after a clean Ubuntu
installation.

where:
    -a, --sysadmin      sets up a sysadmin environment
    -d, --desktop       sets the installation to be done in an Ubuntu Desktop
                        Linux -full base install with GUI and no limitations-
    --developer         sets up a basic development environment
    -h, --help          show this help text
    -j, --javascript    sets up a JavaScript development environment
    -l, --lemp          sets up a LEMP (Linux, Nginx, MySQL, PHP) development
                        environment
    -m, --media         sets up a media workspace
    -n, --nest          sets up a Nest.js development environment
    -q, --quiet         executes the script without any message
    -r, --react         sets up a React.js development environment
    -s, --server        sets the installation to be done in an Ubuntu Server
                        system -no GUI-
    -v, --verbose       print all instructions and comments
    -w, --wordpress     sets up a WordPress development environment
    -y, --yes           answer yes to all yes/no questions
    -x, --next          sets up a Next.js development environment
")

if [ $# -eq 0 ] ; then
  echo $usage ;
  exit 0 ;
fi;

DESKTOP=0;
DEVELOPER=0;
HELP=0;
JAVASCRIPT=0;
LEMP=0;
MEDIA=0;
NEST=0;
NEXT=0;
QUIET=0;
REACT=0;
SERVER=0;
SYSADMIN=0;
VERBOSE=0;
WORDPRESS=0;
YES=0;

PPA_MODIFIERS=""
APT_MODIFIERS=""
WGET_MODIFIERS=""

LOG_FILE=""

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key=$1
  case "$key" in
    -a | --sysadmin )
        DEVELOPER=1;
        SYSADMIN=1;
        shift ;;
    -d | --desktop )
        DESKTOP=1;
        shift ;;
    --developer )
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
    -l | --lemp )
        DEVELOPER=1;
        LEMP=1;
        shift ;;
    -m | --media )
        MEDIA=1;
        shift ;;
    -n | --nest )
        DEVELOPER=1;
        JAVASCRIPT=1;
        NEST=1;
        shift ;;
    -q | --quiet )
        QUIET=1;
        APT_MODIFIERS="q$APT_MODIFIERS"
        PPA_MODIFIERS="q$PPA_MODIFIERS"
        WGET_MODIFIERS="q$WGET_MODIFIERS"
        LOG_FILE="log`date +%Y%m%d`.backup.txt"
        touch $LOG_FILE
        LOG_FILE=">>$LOG_FILE"
        shift ;;
    -r | --react )
        DEVELOPER=1;
        JAVASCRIPT=1;
        REACT=1;
        shift ;;
    -s | --server )
        SERVER=1;
        shift ;;
    -v | --verbose )
        VERBOSE=1;
        shift ;;
    -w | --wordpress )
        DEVELOPER=1;
        LEMP=1;
        WORDPRESS=1;
        shift ;;
    -y | --yes )
        YES=1;
        APT_MODIFIERS="y$APT_MODIFIERS"
        PPA_MODIFIERS="y$PPA_MODIFIERS"
        shift ;;
    -x | --next )
        DEVELOPER=1;
        JAVASCRIPT=1;
        NEXT=1;
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

if [[ $DESKTOP -eq 1 ]] ; then
  SERVER=1 ;
fi

if [[ $VERBOSE -eq 1 ]] ; then
  QUIET=0 ;
fi

create_folder_with_readme() {
  folder_name=$1
  readme_content=$2

  if [ ! -d "$folder_name" ]; then
    if [[ $VERBOSE -eq 1 ]]; then
      echo "Creating folder: $folder_name"
    fi
    mkdir "$folder_name"
    echo "$readme_content" > "$folder_name/README.md"
    if [[ $VERBOSE -eq 1 ]]; then
      echo "README.md created in $folder_name."
    fi
  else
    if [[ $VERBOSE -eq 1 ]]; then
      echo "Folder $folder_name already exists."
    fi
  fi
}

if [[ $APT_MODIFIERS != "" ]]; then APT_MODIFIERS="-$APT_MODIFIERS"; fi

if [[ $PPA_MODIFIERS != "" ]]; then PPA_MODIFIERS="-$PPA_MODIFIERS"; fi

if [[ $WGET_MODIFIERS != "" ]]; then WGET_MODIFIERS="-$WGET_MODIFIERS"; fi

if [[ $VERBOSE -eq 1 ]]; then
  echo " ";
  echo "################################";
  echo "#                              #";
  echo "#         Basic setup          #";
  echo "#                              #";
  echo "################################";
fi

if [[ $VERBOSE -eq 1 ]]; then echo "Enable partners repositories"; fi

sudo sed -i.bak "/^# deb .*partner/ s/^# //" /etc/apt/sources.list

if [[ $VERBOSE -eq 1 ]]; then echo "Partners repositories enabled"; fi

if [[ $VERBOSE -eq 1 ]]; then echo "Enable security updates"; fi

sudo dpkg-reconfigure unattended-upgrades

if [[ $VERBOSE -eq 1 ]]; then echo "Security updates enabled"; fi

if [[ $VERBOSE -eq 1 ]]; then echo "Set basic PPAs up"; fi

sudo add-apt-repository $PPA_MODIFIERS ppa:teejee2008/ppa

if [[ $VERBOSE -eq 1 ]]; then echo "Timeshift PPA added"; fi

if [[ $VERBOSE -eq 1 ]]; then echo "Basic PPAs set"; fi

if [[ $VERBOSE -eq 1 ]]; then echo "Initial Upgrade"; fi

sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS upgrade \
&& sudo apt $APT_MODIFIERS dist-upgrade

if [[ $VERBOSE -eq 1 ]]; then echo "Initial Upgrade Done"; fi

sudo apt $APT_MODIFIERS install flatpak gdebi timeshift \
ubuntu-restricted-extras rar unrar p7zip-full p7zip-rar

flatpak remote-add --if-not-exists flathub \
https://flathub.org/repo/flathub.flatpakrepo

if [ ! -d ~/.ssh ]; then
  mkdir ~/.ssh
  if [[ $VERBOSE -eq 1 ]]; then echo ".ssh folder created."; fi
else
  if [[ $VERBOSE -eq 1 ]]; then echo ".ssh folder already exists."; fi
fi

if [ ! -f ~/.ssh/config ]; then
  touch ~/.ssh/config
  if [[ $VERBOSE -eq 1 ]]; then
    echo "config file created into the .ssh folder."
  fi
else
  if [[ $VERBOSE -eq 1 ]]; then
    echo "config file already exists in the .ssh folder."
  fi
fi

read -p "Which keys do you want to create? " KEYS

for KEY in $KEYS; do
  if [ ! -f ~/.ssh/$KEY ] && [ ! -f ~/.ssh/$KEY.pub ]; then
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/$KEY -q -N ""
    if [[ $VERBOSE -eq 1 ]]; then
      echo "Public-Private keys for $KEY generated into the .ssh folder."
    fi
  else
    if [[ $VERBOSE -eq 1 ]]; then
      echo "Public-Private keys for $KEY already exist in the .ssh folder."
    fi
  fi
done

echo 'HISTTIMEFORMAT="%F %T "' >> ~/.bashrc

if [ ! -f ~/.bash_aliases ]; then
  touch ~/.bash_aliases
  if [[ $VERBOSE -eq 1 ]]; then echo ".bash_aliases file created."; fi
else
  if [[ $VERBOSE -eq 1 ]]; then echo ".bash_aliases file already exists."; fi
fi

echo "alias sysupdate='sudo apt -qy update && sudo apt -qy --fix-broken install && sudo apt -qy autoclean && sudo apt -qy clean && sudo apt -qy autoremove && sudo apt -qy update && sudo apt -qy upgrade && sudo apt -qy dist-upgrade && sudo apt -qy autoclean && sudo apt -qy clean && sudo apt -qy autoremove'" >> ~/.bash_aliases
if [[ $VERBOSE -eq 1 ]]; then
  echo "sysupdate alias added to .bash_aliases file."
fi

echo "alias ssh-alias='read -p \"Alias name: \" ALIAS;read -p \"Host name or IP: \" HOST_ADDRESS;read -p \"Host user: \" HOST_USER;echo \"Choose your Identity to connect: \";for identity in \$(ls ~/.ssh | grep .pub); do echo \${identity/.pub/};done;read -p \"> \" IDENTITY;echo -e \"\\nHost \$ALIAS\\n\\tHostName \$HOST_ADDRESS\\n\\tUser \$HOST_USER\\n#\\tIdentityFile ~/.ssh/\$IDENTITY\" >> ~/.ssh/config;echo -e \"Please execute ssh \$ALIAS to setup your \$IDENTITY public key\\nTo ease the process, we will show the public key below this line\\n\";cat ~/.ssh/\$IDENTITY.pub'" >> ~/.bash_aliases
if [[ $VERBOSE -eq 1 ]]; then
  echo "ssh-alias alias added to .bash_aliases file."
fi

source ~/.bashrc

if [[ $DEVELOPER -eq 1 ]]; then

  sudo apt $APT_MODIFIERS install apt-transport-https ca-certificates curl git \
  gnupg libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 \
  libxss1 libasound2 libxtst6 lsb-release software-properties-common wget \
  xauth xvfb

  if [[ $VERBOSE -eq 1 ]]; then echo "Basic dev tools installed"; fi

fi

folders_and_explanations=(
  "Projects;# Projects\n\nIndividual projects with specific outcomes and deadlines."
  "Areas;# Areas\n\nOngoing areas of responsibility without specific deadlines."
  "Resources;# Resources\n\nCollections of information or material that can be referenced or utilized as needed."
  "Archives;# Archives\n\nCompleted projects, inactive areas, and outdated resources."
)

if [ ! -d ~/Work ]; then
  mkdir ~/Work
  if [[ $VERBOSE -eq 1 ]]; then echo "Work folder created."; fi
else
  if [[ $VERBOSE -eq 1 ]]; then echo "Work folder already exists."; fi
fi

for folder_and_explanation in "${folders_and_explanations[@]}"; do
  folder_name=${folder_and_explanation%%;*}
  explanation=${folder_and_explanation#*;}
  create_folder_with_readme "~/Work/$folder_name" "$explanation"
done

if [[ $VERBOSE -eq 1 ]]; then
  echo "P.A.R.A. system folders and README.md files have been created."
fi

if [[ $SERVER -eq 1 ]]; then

  if [[ $VERBOSE -eq 1 ]]; then
    echo " ";
    echo "###############################";
    echo "#                             #";
    echo "#      Server-type Setup      #";
    echo "#                             #";
    echo "###############################";
  fi

  sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS upgrade \
  && sudo apt $APT_MODIFIERS dist-upgrade

  if [[ $VERBOSE -eq 1 ]]; then echo "Basic security setup"; fi

  if [ $(sudo ufw status verbose | grep inactive | wc -l) -eq 1 ]; then
    sudo ufw enable
  fi

  sudo dpkg-reconfigure unattended-upgrades

  if [[ $VERBOSE -eq 1 ]]; then echo "Basic security set"; fi

  if [[ $VERBOSE -eq 1 ]]; then echo "Espanso install"; fi

  wget https://github.com/federico-terzi/modulo/releases/latest/download/modulo-x86_64.AppImage

  chmod u+x modulo-x86_64.AppImage

  sudo mv modulo-x86_64.AppImage /usr/bin/modulo

  wget https://github.com/federico-terzi/espanso/releases/latest/download/espanso-debian-amd64.deb

  sudo apt $APT_MODIFIERS install ./espanso-debian-amd64.deb

  espanso start

  rm espanso-debian-amd64.deb

  if [[ $VERBOSE -eq 1 ]]; then echo "Espanso installed"; fi

  if [[ $JAVASCRIPT -eq 1 ]]; then

    if ! command -v nvm &> /dev/null; then
      if [[ $VERBOSE -eq 1 ]]; then echo "Installing NVM..."; fi
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
      source ~/.nvm/nvm.sh
    else
      if [[ $VERBOSE -eq 1 ]]; then echo "NVM is already installed"; fi
    fi

    if [[ $VERBOSE -eq 1 ]]; then
    
      echo "Install current Node and NPM LTSs";
    
    fi

    nvm install 18
    nvm use 18

    if ! command -v yarn &> /dev/null; then
      if [[ $VERBOSE -eq 1 ]]; then echo "Installing Yarn..."; fi
      npm install -g yarn
    else
      if [[ $VERBOSE -eq 1 ]]; then echo "Yarn is already installed";  fi
    fi

  fi

fi

if [[ $DESKTOP -eq 1 ]]; then

  if [[ $VERBOSE -eq 1 ]]; then
    echo " ";
    echo "###############################";
    echo "#                             #";
    echo "#     Desktop-type Setup      #";
    echo "#                             #";
    echo "###############################";
  fi

  sudo add-apt-repository $PPA_MODIFIERS ppa:alessandro-strada/ppa

  if [[ $VERBOSE -eq 1 ]]; then echo "Google Drive OCamLFuse PPA added"; fi

  sudo add-apt-repository $PPA_MODIFIERS ppa:agornostal/ulauncher

  if [[ $VERBOSE -eq 1 ]]; then echo "Ulauncher PPA added"; fi

  sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS upgrade \
  && sudo apt $APT_MODIFIERS dist-upgrade

  if [ ! -d ~/Downloads ]; then
    mkdir ~/Downloads
    if [[ $VERBOSE -eq 1 ]]; then echo "Downloads folder created."; fi
  else
    if [[ $VERBOSE -eq 1 ]]; then echo "Downloads folder already exists."; fi
  fi

  cd ~/Downloads

  wget $WGET_MODIFIERS \
  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

  if [[ $VERBOSE -eq 1 ]]; then echo "Google Chrome downloaded"; fi

  sudo dpkg -i google-chrome-stable_current_amd64.deb

  if [[ $VERBOSE -eq 1 ]]; then echo "Google Chrome installed"; fi

  wget $WGET_MODIFIERS \
  https://www.scootersoftware.com/bcompare-4.3.7.25118_amd64.deb

  if [[ $VERBOSE -eq 1 ]]; then echo "Beyond Compare downloaded"; fi

  sudo gdebi -n bcompare-4.3.7.25118_amd64.deb

  if [[ $VERBOSE -eq 1 ]]; then echo "Beyond Compare installed"; fi

  rm bcompare-4.3.7.25118_amd64.deb google-chrome-stable_current_amd64.deb

  if [[ $VERBOSE -eq 1 ]]; then echo "Installation files deleted"; fi

  if [[ $VERBOSE -eq 1 ]]; then echo "Install basic tools"; fi

  sudo apt $APT_MODIFIERS install chrome-gnome-shell  \
  gnome-software-plugin-flatpak gnome-shell-extensions gnome-tweaks \
  google-drive-ocamlfuse laptop-mode-tools libdvd-pkg nautilus-actions \
  qt5-style-kvantum qt5-style-kvantum-themes synaptic terminator \
  thunderbird transmission ttf-mscorefonts-installer \
  ulauncher vlc

  if [[ $VERBOSE -eq 1 ]]; then echo "Basic tools installed"; fi

  if [[ $VERBOSE -eq 1 ]]; then echo "Basic configurations"; fi

  sudo dpkg-reconfigure libdvd-pkg

  sudo apt $APT_MODIFIERS purge ubuntu-web-launchers

  gsettings set org.gnome.desktop.interface show-battery-percentage true

  echo "export QT_STYLE_OVERRIDE=kvantum" >> ~/.profile

  if [[ $VERBOSE -eq 1 ]]; then echo "Basic configurations done"; fi

  if [[ $VERBOSE -eq 1 ]]; then echo "Installing Telegram"; fi

  sudo add-apt-repository $PPA_MODIFIERS ppa:atareao/telegram

  sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS upgrade \
  && sudo apt $APT_MODIFIERS dist-upgrade

  sudo apt $APT_MODIFIERS install -f telegram

  if [[ $VERBOSE -eq 1 ]]; then echo "Telegram installed"; fi

  if [[ $MEDIA -eq 1 ]]; then

    if [[ $VERBOSE -eq 1 ]]; then
      echo " ";
      echo "################################";
      echo "#                              #";
      echo "#         Media setup          #";
      echo "#                              #";
      echo "################################";
    fi

    if [[ $VERBOSE -eq 1 ]]; then echo "# Installing media tools"; fi

    sudo apt $APT_MODIFIERS install gimp imagemagick inkscape

    if [[ $VERBOSE -eq 1 ]]; then echo "# Media tools installed"; fi

  fi

  if [[ $SYSADMIN -eq 1 ]]; then

    if [[ $VERBOSE -eq 1 ]]; then
      echo " ";
      echo "################################";
      echo "#                              #";
      echo "#  Sysadmin development setup  #";
      echo "#                              #";
      echo "################################";
    fi

    if [[ $VERBOSE -eq 1 ]]; then echo "Adding TeamViewer PPA"; fi

    wget $WGET_MODIFIERS \
    https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc -O- \
    | sudo apt-key $PPA_MODIFIERS add - && sudo add-apt-repository $PPA_MODIFIERS \
    "deb http://linux.teamviewer.com/deb stable main"

    if [[ $VERBOSE -eq 1 ]]; then echo "Adding AngryIP Scan PPA"; fi

    sudo add-apt-repository $PPA_MODIFIERS ppa:upubuntu-com/network

    if [[ $VERBOSE -eq 1 ]]; then echo "Adding AnyDesk PPA"; fi

    wget $WGET_MODIFIERS https://keys.anydesk.com/repos/DEB-GPG-KEY -O- \
    | sudo apt-key $PPA_MODIFIERS add - && echo \
    "deb http://deb.anydesk.com/ all main" | sudo tee \
    /etc/apt/sources.list.d/anydesk-stable.list

    if [[ $VERBOSE -eq 1 ]]; then echo "Updating sources"; fi

    sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS upgrade \
    && sudo apt $APT_MODIFIERS dist-upgrade

    if [[ $VERBOSE -eq 1 ]]; then echo "Installing SysAdmin's basics"; fi

    sudo apt $APT_MODIFIERS install anydesk iperf3 ipscan net-tools nmap remmina \
    teamviewer

    if [[ $VERBOSE -eq 1 ]]; then echo "SysAdmin's basics"; fi

  fi

  if [[ $DEVELOPER -eq 1 ]]; then

    if [[ $VERBOSE -eq 1 ]]; then
      echo " ";
      echo "################################";
      echo "#                              #";
      echo "#       Developer setup        #";
      echo "#                              #";
      echo "################################";
    fi

    if [[ $VERBOSE -eq 1 ]]; then echo "Installing VS Code"; fi

    wget $WGET_MODIFIERS https://packages.microsoft.com/keys/microsoft.asc -O- \
    | sudo apt-key $PPA_MODIFIERS add - && sudo add-apt-repository $PPA_MODIFIERS \
    "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

    sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS upgrade \
    && sudo apt $APT_MODIFIERS dist-upgrade

    sudo apt $APT_MODIFIERS install code

    if [[ $VERBOSE -eq 1 ]]; then echo "Installing VS Code basic extesions"; fi

    # https://marketplace.visualstudio.com/items?itemName=HookyQR.beautify
    code --install-extension HookyQR.beautify

    # https://marketplace.visualstudio.com/items?itemName=ysemeniuk.emmet-live
    code --install-extension ysemeniuk.emmet-live

    # https://marketplace.visualstudio.com/items?itemName=felipecaputo.git-project-manager
    code --install-extension felipecaputo.git-project-manager

    # https://marketplace.visualstudio.com/items?itemName=johnpapa.read-time
    code --install-extension johnpapa.read-time

    # https://marketplace.visualstudio.com/items?itemName=Gydunhn.vsc-essentials
    code --install-extension Gydunhn.vsc-essentials

    # https://marketplace.visualstudio.com/items?itemName=TabNine.tabnine-vscode
    code --install-extension TabNine.tabnine-vscode

    if [[ $VERBOSE -eq 1 ]]; then echo "VS Code installed"; fi

    if [[ $VERBOSE -eq 1 ]]; then echo "Installing Insomnia"; fi

    echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \ | sudo tee -a \
    /etc/apt/sources.list.d/insomnia.list && wget --quiet -O - \
    https://insomnia.rest/keys/debian-public.key.asc \ | sudo apt-key add -

    sudo apt $APT_MODIFIERS install insomnia

    if [[ $VERBOSE -eq 1 ]]; then echo "Insomnnia installed"; fi

  fi

  if [[ $LEMP -eq 1 ]]; then

    if [[ $VERBOSE -eq 1 ]]; then

      echo "Installing VS Code extesions for PHP development";
    
    fi

    # https://marketplace.visualstudio.com/items?itemName=dudemelo.php-essentials
    code --install-extension dudemelo.php-essentials

    # https://marketplace.visualstudio.com/items?itemName=phproberto.vscode-php-getters-setters
    code --install-extension phproberto.vscode-php-getters-setters

  fi

  if [[ $WORDPRESS -eq 1 ]]; then

    if [[ $VERBOSE -eq 1 ]]; then

      echo "Installing VS Code extesions for WordPress development";
    
    fi

    # https://marketplace.visualstudio.com/items?itemName=ashiqkiron.gutensnip
    code --install-extension ashiqkiron.gutensnip

    # https://marketplace.visualstudio.com/items?itemName=hridoy.wordpress
    code --install-extension hridoy.wordpress

    # https://marketplace.visualstudio.com/items?itemName=wordpresstoolbox.wordpress-toolbox
    code --install-extension wordpresstoolbox.wordpress-toolbox

    # https://marketplace.visualstudio.com/items?itemName=tungvn.wordpress-snippet
    code --install-extension tungvn.wordpress-snippet

    # https://marketplace.visualstudio.com/items?itemName=anthonydiametrix.ACF-Snippet
    code --install-extension anthonydiametrix.ACF-Snippet

    # https://marketplace.visualstudio.com/items?itemName=claudiosanches.woocommerce
    code --install-extension claudiosanches.woocommerce

    # https://marketplace.visualstudio.com/items?itemName=claudiosanches.wpcs-whitelist-flags
    code --install-extension claudiosanches.wpcs-whitelist-flags

  fi

  if [[ $JAVASCRIPT -eq 1 ]]; then

    if [[ $VERBOSE -eq 1 ]]; then
      echo "Install VSCode extensions for Javascript development";
    fi

    # https://marketplace.visualstudio.com/items?itemName=xabikos.JavaScriptSnippets
    code --install-extension xabikos.JavaScriptSnippets

    # https://marketplace.visualstudio.com/items?itemName=Wilson-Godoi.wg-getters-and-setters
    code --install-extension Wilson-Godoi.wg-getters-and-setters

  fi

  if [[ $VERBOSE -eq 1 ]]; then

    echo "A special extra: Installing a Deadpool GRUB theme";

  fi

  git clone https://github.com/satyakami/grub2-deadpool-theme.git

  cd grub2-deadpool-theme

  chmod 755 install.sh

  sudo ./install.sh

  cd ..

  rm -r grub2-deadpool-theme

  if [[ $VERBOSE -eq 1 ]]; then echo "# Deadpool GRUB theme installed"; fi

fi

if [[ $VERBOSE -eq 1 ]]; then
  echo " ";
  echo "###############################";
  echo "#                             #";
  echo "#       System clean up       #";
  echo "#                             #";
  echo "###############################";
fi

sudo apt $APT_MODIFIERS update
sudo apt $APT_MODIFIERS --fix-broken install
sudo apt $APT_MODIFIERS autoclean
sudo apt $APT_MODIFIERS clean
sudo apt $APT_MODIFIERS autoremove
sudo apt $APT_MODIFIERS update

echo "All operations done!"