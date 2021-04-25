#!/bin/bash

usage=$("after-install 1.0.0
Usage: after-install [{-h | --help}] [{-a | --angular}] [{-d | --developer}]
                        [{-j | --javascript}] [{-p | --php}] [{-m | --media}]
                        [--nx] [{-q | --quiet}] [{-s | --sysadmin}]
                        [{-v | --verbose}] [{-w | --wordpress}] [{-y | --yes}]

after-install is a script to set up a base environment after a clean Ubuntu
installation.

where:
    -a, --angular       sets up an angular development environment
    -d, --developer     sets up a basic development environment
    -h, --help          show this help text
    -j, --javascript    sets up a javascript development environment
    -l, --lemp          sets up a LEMP (Linux, Nginx, MySQL, PHP) development
                        environment
    -m, --media         sets up a media workspace
    --nx                sets up a NX development environment
    -q, --quiet         executes the script without any message
    -s, --sysadmin      sets up a sysadmin environment
    -v, --verbose       print all instructions and comments
    -w, --wordpress     sets up a WordPress development environment
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
LEMP=0;
MEDIA=0;
NX=0;
QUIET=0;
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
    -l | --lemp )
        DEVELOPER=1;
        LEMP=1;
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

if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Espanso install"; fi

wget https://github.com/federico-terzi/modulo/releases/latest/download/modulo-x86_64.AppImage

chmod u+x modulo-x86_64.AppImage

sudo mv modulo-x86_64.AppImage /usr/bin/modulo

wget https://github.com/federico-terzi/espanso/releases/latest/download/espanso-debian-amd64.deb

sudo apt $APT_MODIFIERS install ./espanso-debian-amd64.deb

espanso start

rm espanso-debian-amd64.deb

if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Espanso installed"; fi



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

  sudo apt $APT_MODIFIERS install apt-transport-https ca-certificates curl git \
  gnupg libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 \
  libxss1 libasound2 libxtst6 lsb-release software-properties-common wget \
  xauth xvfb

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Basic tools installed"; fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Generating SSH Keys"; fi

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

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "## Installing VS Code basic extesions"; fi

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

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# VS Code installed"; fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Installing Insomnia"; fi

  echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \ | sudo tee -a \
  /etc/apt/sources.list.d/insomnia.list && wget --quiet -O - \
  https://insomnia.rest/keys/debian-public.key.asc \ | sudo apt-key add -

  sudo apt $APT_MODIFIERS install insomnia

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Insomnnia installed"; fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Installing Telegram"; fi

  sudo add-apt-repository $PPA_MODIFIERS ppa:atareao/telegram

  sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS upgrade \
  && sudo apt $APT_MODIFIERS dist-upgrade

  sudo apt $APT_MODIFIERS install -f telegram

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Telegram installed"; fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then

    echo "# Developer's tools installed";

  fi

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

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Adding TeamViewer PPA"; fi

  wget $WGET_MODIFIERS \
  https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc -O- \
  | sudo apt-key $PPA_MODIFIERS add - && sudo add-apt-repository $PPA_MODIFIERS \
 "deb http://linux.teamviewer.com/deb stable main"

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Adding AngryIP Scan PPA"; fi

  sudo add-apt-repository $PPA_MODIFIERS ppa:upubuntu-com/network

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Adding AnyDesk PPA"; fi

  wget $WGET_MODIFIERS https://keys.anydesk.com/repos/DEB-GPG-KEY -O- \
  | sudo apt-key $PPA_MODIFIERS add - && echo \
  "deb http://deb.anydesk.com/ all main" | sudo tee \
  /etc/apt/sources.list.d/anydesk-stable.list

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Updating sources"; fi

  sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS upgrade \
  && sudo apt $APT_MODIFIERS dist-upgrade

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Installing SysAdmin's basics"; fi

  sudo apt $APT_MODIFIERS install anydesk iperf3 ipscan net-tools nmap remmina \
  teamviewer

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# SysAdmin's basics"; fi

fi



if [[ $LEMP -eq 1 ]]; then

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
    echo " ";
    echo "################################";
    echo "#                              #";
    echo "#    LEMP development setup    #";
    echo "#                              #";
    echo "################################";
  fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then

    echo "## Installing & settign up Nginx";
  
  fi

  sudo apt $APT_MODIFIERS install nginx

  N_CORES=$(grep processor /proc/cpuinfo | wc -l)
  N_PROCESSES=$(ulimit -n)

  sudo sed -i -e "s/www-data/${USER}/g" \
  -e "s/worker_processes 4\;/worker_processes $N_CORES\;/g" \
  -e "s/worker_processes auto\;/worker_processes $N_CORES\;/g" \
  -e "s/worker_connections 768\;/worker_connections $(($N_CORES * $N_PROCESSES))\;/g" \
  -e "s/\# multi_accept on/multi_accept on/g" \
  -e "s/keepalive_timeout 65/keepalive_timeout 15/g" \
  -e "s/\# server_tokens/server_tokens/g" \
  -e "s/server_tokens on/server_tokens off/g" \
  -e "s/server_tokens off\;/server_tokens off\;\n\tclient_max_body_size 64m\;/g" \
  -e "s/TLSv1 TLSv1.1 //g" \
  -e "s/# gzip_proxied/gzip_proxied/g" \
  -e "s/# gzip_comp_level/gzip_comp_level/g" \
  -e "s/gzip_comp_level 6/gzip_comp_level 5/g" \
  -e "s/# gzip_types/gzip_types/g" \
  -e "s/TLSv1 TLSv1.1 //g" \
  -e "s/\/etc\/nginx\/sites-enabled\/\*\;/\/etc\/nginx\/sites-enabled\/\*\;\n\n\tserver \{\n\t\tlisten 80 default_server\;\n\t\tlisten \[\:\:\]\:80 default_server\;\n\t\tserver_name _\;\n\t\treturn 444\;\n\t\}/g" \
  -e "s/Virtual Host Configs/Security Settings\n\t\#\#\n\n\tadd_header Strict-Transport-Security \"max-age=31536000\; includeSubdomains\"\;\n\tssl_session_cache shared\:SSL\:10m\;\n\tssl_session_timeout 10m\;\n\tadd_header Content-Security-Policy \"default-src 'self' https\:\/\/*.google-analytics.com https\:\/\/*.googleapis.com https\:\/\/*.gstatic.com https\:\/\/*.gravatar.com https\:\/\/*.w.org data\: 'unsafe-inline' 'unsafe-eval'\;\" always\;\n\tadd_header X-Xss-Protection \"1\; mode=block\" always\;\n\tadd_header X-Frame-Options \"SAMEORIGIN\" always\;\n\tadd_header X-Content-Type-Options \"nosniff\" always\;\n\tadd_header Referrer-Policy \"origin-when-cross-origin\" always\;\n\n\t\#\#\n\t\# Virtual Host Configs/g" \
  /etc/nginx/nginx.conf

  sudo sed -i -e "s/\$fastcgi_script_name\;/\$fastcgi_script_name\;\nfastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;/g" \
  /etc/nginx/fastcgi_params

  sudo rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

  sudo service nginx restart



  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then

    echo "## Installing & settign up PHP";
  
  fi

  sudo add-apt-repository $PPA_MODIFIERS ppa:ondrej/php
  sudo apt $APT_MODIFIERS update
  sudo apt $APT_MODIFIERS install php7.4-fpm php7.4-common php7.4-mysql \
  php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd \
  php7.4-imagick php7.4-cli php7.4-dev php7.4-imap \
  php7.4-mbstring php7.4-opcache php7.4-redis \
  php7.4-soap php7.4-zip

  sudo sed -i -e "s/\= www-data/\= ${USER}/g" \
  /etc/php/7.4/fpm/pool.d/www.conf

  sudo sed -i -e "s/upload_max_filesize \= 2M/upload_max_filesize \= 64M/g" \
  -e "s/post_max_size \= 8M/post_max_size \= 64M/g" \
  /etc/php/7.4/fpm/php.ini

  sudo service php7.4-fpm restart



  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then

    echo "## Installing & settign up Redis Cache";
  
  fi

  sudo apt $APT_MODIFIERS install redis-server

  sudo service php7.4-fpm restart



  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then

    echo "## Installing & settign up MariaDB";
  
  fi

  sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'

  sudo add-apt-repository $PPA_MODIFIERS 'deb [arch=amd64,arm64,ppc64el] http://mirrors.up.pt/pub/mariadb/repo/10.4/ubuntu focal main'

  sudo apt $APT_MODIFIERS install mariadb-server

  sudo mysql_secure_installation



  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then

    # echo "## Installing & settign up Let's Encrypt";
  
  fi

  # sudo add-apt-repository $PPA_MODIFIERS universe

  # sudo apt $APT_MODIFIERS update

  # sudo apt $APT_MODIFIERS install certbot python3-certbot-nginx

  # sudo certbot --nginx certonly -d ashleyrich.com -d www.ashleyrich.com # @TODO



  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then

    echo "## Installing VS Code extesions for PHP development";
  
  fi

  # https://marketplace.visualstudio.com/items?itemName=dudemelo.php-essentials
  code --install-extension dudemelo.php-essentials

  # https://marketplace.visualstudio.com/items?itemName=phproberto.vscode-php-getters-setters
  code --install-extension phproberto.vscode-php-getters-setters

fi



if [[ $WORDPRESS -eq 1 ]]; then

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
    echo " ";
    echo "################################";
    echo "#                              #";
    echo "# WordPress development setup  #";
    echo "#                              #";
    echo "################################";
  fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then

    echo "## Installing & settign up WP-CLI";
  
  fi

  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

  chmod +x wp-cli.phar

  sudo mv wp-cli.phar /usr/local/bin/wp

  # wp package install git@github.com:wp-cli/checksum-command.git # https://github.com/wp-cli/checksum-command <- Problemas!!!!
  # wp package install git@github.com:wp-cli/doctor-command.git # https://github.com/wp-cli/doctor-command
  # wp package install git@github.com:wp-cli/i18n-command.git # https://github.com/wp-cli/i18n-command
  # wp package install git@github.com:wp-cli/profile-command.git # https://github.com/wp-cli/profile-command
  # wp package install binarygary/db-checkpoint # https://github.com/binarygary/db-checkpoint <- Problemas!!!!



  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then

    echo "## Settign up Nginx for WordPress development";
  
  fi

  sudo sed -i -e "s/Security Settings/Cache Settings\n\t\#\#\n\n\tfastcgi_cache_key \"\$scheme\$request_method\$host\$request_uri\"\;\n\tadd_header Fastcgi-Cache \$upstream_cache_status\;\n\n\t\#\#\n\t\# Security Settings/g" \
  /etc/nginx/nginx.conf

  sudo service nginx restart



  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then

    echo "## Installing VS Code extesions for WordPress development";
  
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

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
    echo " ";
    echo "################################";
    echo "#                              #";
    echo "# Javascript development setup #";
    echo "#                              #";
    echo "################################";
  fi

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then echo "# Install NVM"; fi

  curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | \
  bash && source ~/.profile

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
  
    echo "# Install current Node and NPM LTSs";
  
  fi

  nvm install --lts

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
    echo "# Install VSCode extensions for Javascript development";
  fi

  # https://marketplace.visualstudio.com/items?itemName=xabikos.JavaScriptSnippets
  code --install-extension xabikos.JavaScriptSnippets

  # https://marketplace.visualstudio.com/items?itemName=Wilson-Godoi.wg-getters-and-setters
  code --install-extension Wilson-Godoi.wg-getters-and-setters

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

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
  
    echo "# Install Angular";
  
  fi

  npm install -g @angular/cli

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
    echo "# Install VSCode extensions for Angular development";
  fi

  # https://marketplace.visualstudio.com/items?itemName=johnpapa.angular-essentials
  code --install-extension johnpapa.angular-essentials

  # https://marketplace.visualstudio.com/items?itemName=jakethashi.vscode-angular2-emmet
  code --install-extension jakethashi.vscode-angular2-emmet

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

  if [[ $VERBOSE -eq 1 && $QUIET -eq 0 ]]; then
    echo "# Install VSCode extensions for NX development";
  fi

  # https://marketplace.visualstudio.com/items?itemName=nrwl.angular-console
  code --install-extension nrwl.angular-console

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

sudo apt $APT_MODIFIERS update && sudo apt $APT_MODIFIERS --fix-broken install && sudo apt $APT_MODIFIERS autoclean \
&& sudo apt $APT_MODIFIERS clean && sudo apt $APT_MODIFIERS autoremove \
&& sudo apt $APT_MODIFIERS update
