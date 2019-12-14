#!/bin/bash

NVM_VERSION='0.35.1'
NODE_VERSION='--lts'

##########################################
# Install Node via nvm
##########################################
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
  
  # Load NVM command

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install $NODE_VERSION
nvm use $NODE_VERSION

##########################################
# INSTALL DEV DEPS
##########################################

sudo apt install build-essential -y
sudo apt-get install gcc g++ make -y

##########################################
# Install Nginx and Test
##########################################

#### Install NginX
sudo apt install nginx

#### Enable HTTP Traffic in UFW
sudo ufw allow 'Nginx HTTP'
sudo ufw status

read -p "Verify UFW status? Press Enter."

systemctl status nginx

read -p "Verify NginX System Daemon Status? Press Enter."

echo " "
echo "Checking public IP as visible by other machines."

curl -4 icanhazip.com

echo " "
echo "Checking system's IP Registry"

ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'

read -p 'Please manually verify that NginX is serving content by entering the IP address of this droplet into your web browser. Done?'
read -p 'Set up domain name: ' DOMAIN_NAME

echo "Adding Directory: var/www/$DOMAIN_NAME/html"

sudo mkdir -p /var/www/$DOMAIN_NAME/html
sudo chown -R $USER:$USER /var/www/$DOMAIN_NAME/html
sudo chmod -R 755 /var/www/$DOMAIN_NAME

echo "Building sample index.html: "

sudo cat >> /var/www/$DOMAIN_NAME/html/index.html << EOF
  <html>
      <head>
          <title>Welcome to $DOMAIN_NAME!</title>
      </head>
      <body>
          <h1>Success!  The $DOMAIN_NAME server block is working!</h1>
      </body>
  </html>
EOF

echo "Adding NginX Server Group for $DOMAIN_NAME"

sudo cat >> /etc/nginx/sites-available/$DOMAIN_NAME << EOF
  server {
    listen 80;
    listen [::]:80;

    root /var/www/$DOMAIN_NAME/html;
    index index.html index.htm index.nginx-debian.html;

    server_name $DOMAIN_NAME www.$DOMAIN_NAME;

    location / {
      try_files $uri $uri/ =404;
    }
  }
EOF

# Create a link to the default sites-enabled directory which NginX reads on startup

sudo ln -s /etc/nginx/sites-available/$DOMAIN_NAME /etc/nginx/sites-enabled/

echo 'Please enter /etc/nginx/nginx.conf as sudo'
echo 'Uncomment the "server_names_hash_buck" directive please'
read -p "Press Enter when done."

echo "Making sure we have no errors"

sudo nginx -t

read -p "Continue?"

echo "Restarting NginX"

sudo systemctl restart nginx

echo "Check out http://$DOMAIN_NAME to see your new site in action!"
