npm install pm2@latest -g

mkdir node-init-script && \
cd node-init-script

# 4 escapes in line 18 (each "\")
# First backtick
# In front of both ${} template literals that try to expand a shell var
# Last backtick

cat > hello-world-server.js << EOF
const http = require('http');

const hostname = 'localhost';
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World!\n');
});

server.listen(port, hostname, () => {
  console.log(\`Server running at http://\${hostname}:\${port}/\`);
});
EOF

pm2 start hello-world-server.js
# CONFIGURE PM2 AND ASSOCIATED PROCESSES TO OCCUR ON STARTUP

read -p "You will need to paste into terminal to complete this. Proceed? "
pm2 startup systemd
read -p "Did you paste the content? Proceed. "

# Save PM2 process list and corresponding environments
pm2 save

# SET UP PROXY AT ROOT URL '/' 
# FOR OUR SAMPLE APP RUNNING ON PORT 3000
cat > /etc/nginx/sites-available/$DOMAIN_NAME << EOF 
server {
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

# CAN ADD OTHER APP LOCATIONS AFTER ROOT POINTING TO DIFFERENT PORTS
# ...
# location /app2 {
#       proxy_pass http://localhost:3001;
#
#
#

sudo nginx -t
read -p "Checked NginX Status. Continue?"
echo "Restarting NginX"
sudo systemctl restart nginx