#!/bin/bash
##########################################
## Install Docker on Ubuntu 18.04
##########################################

sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update -y
apt-cache policy docker-ce
sudo apt install docker-ce -y
read -p 'Docker Installed. Press Enter to continue.'
sudo systemctl status docker
# You may need to hit "q" to exit out of the less prompt
read -p "System Status. Press Enter to continue"

##########################################
## Install Docker Compose
##########################################

sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
echo "docker-compose installed."
##########################################
## Add user to "docker" group so that docker doesn't need to be called with "sudo" each time
##########################################
sudo usermod -aG docker ${USER} && \
su - ${USER} && \
id -nG

read -p "Confirm that user has been added to docker group?"
echo "Docker configuration complete."