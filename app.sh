#!/bin/sh

VERSION=$1
IP=$(hostname -i || echo "Unknown IP")
HOST=$(hostname || echo "Unknown Host")

cat <<EOF > /usr/share/nginx/html/index.html
<html>
  <head><title>Info Page</title></head>
  <body>
    <h1>Web App Info</h1>
    <p><strong>IP address:</strong> $IP</p>
    <p><strong>Hostname:</strong> $HOST</p>
    <p><strong>App version:</strong> $VERSION</p>
  </body>
</html>
EOF
