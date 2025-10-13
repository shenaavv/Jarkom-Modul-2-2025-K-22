#!/bin/bash
echo "sirion" > /etc/hostname
hostname sirion
ip route add default via 10.15.43.29

apt update
apt install -y nginx

cat > /etc/nginx/sites-available/sirion_proxy <<'EOF'
server {
    listen 80;
    server_name sirion.K22.com;
    return 301 http://www.K22.com$request_uri;
}
server {
    listen 80;
    server_name www.K22.com;
    location /static/ {
        proxy_pass http://static.K22.com/;
        proxy_set_header Host static.K22.com;
        proxy_set_header X-Real-IP $remote_addr;
    }
    location /app/ {
        proxy_pass http://app.K22.com/;
        proxy_set_header Host app.K22.com;
        proxy_set_header X-Real-IP $remote_addr;
    }
    location = / {
        return 302 /static/;
    }
}
EOF

ln -sf /etc/nginx/sites-available/sirion_proxy /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
service nginx restart
