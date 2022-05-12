#!/bin/bash


# This is an incomplete pre-release for other interested developers to examine. 
# Normal users should not run this script as it's un-finished.
# This script has been re-written for Manjaro Arm Phosh on Pinephone pro

options[0]="Step 1: Install Dependencies"
options[1]="Step 2: Update Time-Sync"
options[2]="Step 3: Download SEPIA Custom-Bundle"
options[3]="Step 4: Extract SEPIA-Home Bundle"
options[4]="Step 5: Install and configue NGINX"
options[5]="Step 6: Sepia Setup"
options[6]="Exit ( ctrl + c)"

#Actions to take based on selection
function ACTIONS {
    if [[ ${choices[0]} ]]; then
    # Install dependencies
        read -p "This will install the following packages:
        glibc ncurses systemd-libs procps-ng zip unzip curl git ca-certificates dpkg openssl gcc glibc ncurses systemd-libs procps-ng zip unzip curl git ca-certificates jre11-openjdk-headless jre11-openjdk jdk11-openjdk openjdk11-doc openjdk11-src wget  hit enter to continue, or ctrl + c to cancel"
        sudo pacman -Syu
        sudo pacman -S glibc ncurses systemd-libs procps-ng zip unzip curl git ca-certificates dpkg openssl gcc glibc ncurses systemd-libs procps-ng zip unzip curl git ca-certificates jre11-openjdk-headless jre11-openjdk jdk11-openjdk openjdk11-doc openjdk11-src wget
        sudo pacman -Syu
        echo "------------------------"
        echo "DONE."
        java -version
        echo "------------------------"
    fi
    if [[ ${choices[1]} ]]; then
    # Update Time-Sync
        echo "Using 'timedatectl' to sync time ..."
        sudo timedatectl set-ntp true
        echo "------------------------"
        echo "DONE."
        echo "------------------------"
    fi   
    if [[ ${choices[2]} ]]; then
        # Download SEPIA Custom-Bundle
#create tmp folder (usually done before getting this file)
        sudo rm -rf ~/SEPIA/tmp
        mkdir -p ~/SEPIA/tmp
        cd ~/SEPIA/tmp
        wget "https://github.com/SEPIA-Framework/sepia-installation-and-setup/releases/latest/download/SEPIA-Home.zip"
        echo "------------------------"
        echo "DONE."
        echo "------------------------"
    fi 
    if [[ ${choices[3]} ]]; then
        # EXTRACT SEPIA-Home bundle
        cd ~/SEPIA/tmp
        unzip SEPIA-Home.zip -d ~/SEPIA 
        # SET SCRIPT ACCESS AND DONE
        #set scripts access
        cd ~/SEPIA
        find . -name "*.sh" -exec chmod +x {} \;
        chmod +x elasticsearch/bin/elasticsearch
        #done
        echo ""
        echo "------------------------"
        echo "DONE :-) If you saw no errors you can exit now and continue with 'cd ~/SEPIA' and 'bash setup.sh'".
        echo "------------------------"
        chmod +x setup.sh
        ./setup.sh
    fi
    if [[ ${choices[4]} ]]; then
       # INSTALL AND CONFIGURE NGIX
       read -p "This will install nginx and ngip-database-extra, and make a directory for it (neccisary). Hit enter to continue, or ctrl + c to cancel."
       sudo mkdir /etc/nginx/sites-enabled/
       echo 'Installing nginx reverse-proxy ...'
       sudo pacman -S nginx geoip-database-extra
       echo "------------------------"  
       read -p "To create a SEPIA Nginx config and setup SSL, we must change directories and run the next step ( cd SEPIA, sed lines 33 and 34 to work with manjaro, ./setup-nginx.sh). Hit enter to continue, or ctrl + c to cancel."
       cd ~/SEPIA
       sed -i '33s/.*/		sudo pacman -Syu/' setup-nginx.sh
       sed -i '34s/.*/		sudo pacman -S nginx/' setup-nginx.sh
       chmod +x setup-nginx.sh
       ./setup-nginx.sh
    fi
    if [[ ${choices[5]} ]]; then
        # SEPIA SETUP
        clear
        echo 'Starting SEPIA setup ...'
        cd ~/SEPIA
        bash setup.sh
        exit
    fi
    if [[ ${choices[6]} ]]; then
        # Exit
        echo "Bye!"
        exit
    fi
}

#Variables 
ERROR= ""

#Clear screen for menu
clear

#Menu function
function MENU {
    echo "Manjaro Arm Sepia Installer v0.0.2 (testing / prerelease)
                   ----
             ----------------
          -----010010100---------
       ------001------0100----------
     -------10----------0000----------
    --------11------------01-----------
   ---------01------------1-------------
  -----------000-------------------------
  -------------0101----------------------
  ---------------101101010---------------
  ----------------------10011------------
  ---------------------------00----------
  ------------10----//\-------01--------
   ---------00-----//--\------00-------
    --------10-----\--//-----100------
     --------011----\//----0110------
       --------1100------01010-----
           -------011010010-----
              -------10------
                    ---"
    for NUM in ${!options[@]}; do
        echo "[""${choices[NUM]:- }""]" $(( NUM+1 ))") ${options[NUM]}"
    done
    echo "$ERROR"
}

#Menu loop
while MENU && read -e -p "Please make a choice.. " -n1 SELECTION && [[ -n "$SELECTION" ]]; do
    clear
    if [[ "$SELECTION" == *[[:digit:]]* && $SELECTION -ge 1 && $SELECTION -le ${#options[@]} ]]; then
        (( SELECTION-- ))
        if [[ "${choices[SELECTION]}" == "+" ]]; then
            choices[SELECTION]=""
        else
            choices[SELECTION]="+"
        fi
            ERROR=" "
    else
        ERROR="Invalid option: $SELECTION"
    fi
done

ACTIONS
