sudo npm install pm2@latest -g

mkdir node-init-script && \
cd node-init-script

# 4 escapes in line 18 (each "\")
# First backtick
# In front of both ${} template literals that try to expand a shell var
# Last backtick

echo cat >> hello-world-server.js << EOF
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