#!/bin/bash
echo "lindon" > /etc/hostname
hostname lindon
ip route add default via 10.15.43.29

apt update
apt install -y nginx

mkdir -p /var/www/static.K22.com/html/annals
echo "<h1>Lindon - K22</h1>" > /var/www/static.K22.com/html/index.html
echo "Archived record" > /var/www/static.K22.com/html/annals/record.txt

cat > /etc/nginx/sites-available/static.K22.com <<'EOF'
server {
    listen 80;
    server_name static.K22.com;
    root /var/www/static.K22.com/html;
    index index.html;
    location /annals/ {
        autoindex on;
        autoindex_localtime on;
    }
}
EOF

ln -sf /etc/nginx/sites-available/static.K22.com /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
service nginx restart
