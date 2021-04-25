# Ubuntu After-Install Setup Script

This script aims at easing the after-install process in which we usually do the
same actions everytime.

## Table of Contents

- [Ubuntu After-Install Setup Script](#ubuntu-after-install-setup-script)
  - [Table of Contents](#table-of-contents)
  - [Intro](#intro)
  - [Technologies](#technologies)
  - [How to use it](#how-to-use-it)
    - [Examples](#examples)
  - [Features](#features)
  - [Sources](#sources)
  - [Status](#status)
  - [Contact](#contact)

## Intro

Everytime I install Ubuntu in a new laptop, I google _Ubuntu {version} after
install_ and I get lots of posts that -essentially- have the same info. Moreover, this info don't usually change from version to version.

Thus, I've created this project to automate all the actions for each of the jobs I usually do.

Over time, I've tried to expand this script's features to cover other jobs.

## Technologies

After-Install is created with:

- Shellscript

## How to use it

```bash
wget https://github.com/borjalofe/ubuntu-after-install-setup/blob/main/after-install.sh
chmod +x after-install.sh
./after-install.sh
```

`./after-install.sh` displays the following usage message:

```bash
after-install 1.0.0
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
    -y, --yes           answer yes to all yes/no questions
```

### Examples

To install a basic Angular dev env, you just need to write: `./after-install.sh -a` or `./after-install.sh --angular`

## Features

- Do all basic after-install actions you usually read in a "X things to do after install Ubuntu yy.mm" automatically
  - First upgrade
  - Enable Ubuntu's partners repos
  - Install Gnome Shell extensions
  - Install Gnome Tweak Tool
  - Install Laptop Mode Tools
  - Install third-party codecs -Ubuntu restricted extras and libdvd-
  - Install Microsoft fonts
  - Install software:
    - Flatpak and Synaptic
    - Google Chrome -and Gnome Shell extension for Chrome-
    - Skype
    - Steam
    - Thunderbird
    - Timeshift
    - Transmission
    - Ulauncher
    - VLC
  - Install tools:
    - Compressors -rar, p7zip-
    - Terminator
- Prepare your newly installed Ubuntu for your daily work
  - In the _developer_ mode:
    - Install dev packages to allow dev and testing
    - Generates a SSH key with a 1024-char passphrase
    - Install VSCode - Code editor -
      - Install Beautify
      - Install Emmet -HTML/CSS expander-
      - Install git project manager
      - Install Read Time -for MarkDown files-
      - Install VSC Essentials
    - Install Insomnia - API testing -
    - Install Telegram
  - In the _Javascript developer_ mode:
    - Install NVM
    - Install Node&NPM LTS
    - Install VSCode Javascript extensions
      - Install Javascript ES6 Code Snippets
      - Install Typescript's Getters and Setters
  - In the _Angular developer_ mode:
    - Install Angular CLI
    - Install VSCode Angular extensions
      - Install Angular Essentials
      - Install Angular Emmet -Angular expander-
  - In the _NX developer_ mode:
    - Install VSCode Angular extensions
      - Install NX Angular Console

ToDo:

- Add an easy way to extend after-install actions with an updated usage message
- Get git user info to setup local git
- Install and setup Docker and add usual .dockerfile
  - Javascript
  - Angular
  - NX
  - PHP/MySQL
  - WordPress
- Install and setup Slack
- Install usual Google Chrome extensions
- Install usual Thunderbird extensions
- Install usual VSCode extensions for each development env
  - PHP/MySQL
  - WordPress
- Setup Google Drive OCamLFuse
- Setup Timeshift
- Setup Ulauncher

## Sources

1. *env_setup* at [codediem-dev-env -at GitLab-](https://gitlab.com/borjalofe/codediem-dev-env)

## Status

This project is currently being developed.

## Contact

Created by [@borjalofe](https://github.com/borjalofe) - feel free to contact me!
