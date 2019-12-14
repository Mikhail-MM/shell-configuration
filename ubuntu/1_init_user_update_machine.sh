#!/bin/bash

##########################################
# This script is run on a new Digital Ocean droplet
# It updates the machine's packages 
# (apt & apt-get)
##########################################

#### ##########################################
#Upgrade Ubuntu 18.04 Package Managers

##############################################

sudo apt-get update -y && \
sudo apt-get upgrade -y && \
sudo apt update -y && \
sudo apt upgrade -y

##########################################
# Create new user (PW authorization setup)
##########################################

echo 'Creating new sudo-authorized user:'
read -p 'Select Username: ' NEW_LINUX_USER
adduser $NEW_LINUX_USER

##########################################
# Add new user to sudo group
##########################################
usermod -aG sudo $NEW_LINUX_USER

##########################################
# Enable UFW Firewall (Allow SSH Traffic)
##########################################

echo 'Configuring Firewall to allow SSH traffic only'
### Allow SSH connections through OpenSSH
ufw allow OpenSSH
ufw enable
ufw status

##########################################
# INITIATE SSH KEY
##########################################

# Does not work with quotes around filepath
if [[ -f .ssh/id_rsa && -f .ssh/id_rsa.pub ]]; then
  echo 'Found id_rsa public key'
else
  echo 'Could not find existing id_rsa public key'
  echo 'Creating one now.'
  ssh-keygen -t rsa -b 4096 -C "DO-40BUX-DROPLET"
  # TODO - Add SSH-AGENT to handle passphrase automatically
  rsync --archive --chown=$NEW_LINUX_USER:$NEW_LINUX_USER ~/.ssh /home/$NEW_LINUX_USER
fi

echo "Re-Booting System..."

reboot
