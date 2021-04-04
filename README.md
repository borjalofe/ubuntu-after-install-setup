# Ubuntu After-Install Setup Script

This script aims at easing the after-install process in which we usually do the
same actions everytime.

## Table of Contents

* [Intro](#intro)
* [Technologies](#technologies)
* [How to use it](#how-to-use-it)
  * [Examples](#examples)
* [Features](#features)
* [Status](#status)
* [Contact](#contact)

## Intro

Everytime I install Ubuntu in a new laptop, I google _Ubuntu {version} after
install_ and I get lots of posts that -essentially- have the same info.
Moreover, this info don't usually change between versions.

Thus, I've created this project to have all that actions automated for each of
the jobs I usually do.

Over the time, I've tried to expand this script's features to cover other jobs.

## Technologies

After-Install is created with:

* Shellscript

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
```

### Examples

To install a basic Angular dev env, you just need to write: `./after-install.sh -a` or `./after-install.sh --angular`

## Features

* Do all basic after-install actions you usually read in a "X things to do after install Ubuntu yy.mm" automatically
  * First upgrade
  * Enable Ubuntu's partners repos
  * Install Gnome Shell extensions
  * Install Gnome Tweak Tool
  * Install Laptop Mode Tools
  * Install third-party codecs -Ubuntu restricted extras and libdvd-
  * Install Microsoft fonts
  * Install software:
    * Flatpak and Synaptic
    * Google Chrome -and Gnome Shell extension for Chrome-
    * Skype
    * Steam
    * Thunderbird
    * Timeshift
    * Transmission
    * Ulauncher
    * VLC
  * Install tools:
    * Compressors -rar, p7zip-
    * Terminator
* Prepare your newly installed Ubuntu for your daily work
  * Install VSCode

ToDo:

* Add an easy way to extend after-install actions with an updated usage message
* Get git user info to setup local git
* Install and setup Docker and add usual .dockerfile
  * Javascript
  * Angular
  * NX
  * PHP/MySQL
  * WordPress
* Install and setup Slack 
* Install usual Google Chrome extensions
* Install usual Thunderbird extensions
* Install usual VSCode extensions for each development env
  * Basic
  * Javascript
  * Angular
  * NX
  * PHP/MySQL
  * WordPress
* Setup Google Drive OCamLFuse
* Setup Timeshift
* Setup Ulauncher

## Status

This project is being developed.

## Contact

Created by [@borjalofe](https://github.com/borjalofe) - feel free to contact me!
