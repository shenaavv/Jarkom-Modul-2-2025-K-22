#!/bin/bash
echo "vingilot" > /etc/hostname
hostname vingilot
ip route add default via 10.15.43.29

apt update
apt install -y wget ca-certificates gnupg
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg --no-check-certificate
echo "deb https://packages.sury.org/php/ bookworm main" > /etc/apt/sources.list.d/php.list
apt update
apt install -y nginx php8.4-fpm

mkdir -p /var/www/app.K22.com/html
echo '<?php echo "<h1>Vingilot Home</h1>"; ?>' > /var/www/app.K22.com/html/index.php
echo '<?php echo "<h1>About Page</h1>"; ?>' > /var/www/app.K22.com/html/about.php

cat > /etc/nginx/sites-available/app.K22.com <<'EOF'
server {
    listen 80;
    server_name app.K22.com;
    root /var/www/app.K22.com/html;
    index index.php;
    location / {
        try_files $uri $uri/ @rewrite;
    }
    location @rewrite {
        rewrite ^/about$ /about.php last;
    }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF

ln -sf /etc/nginx/sites-available/app.K22.com /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
service php8.4-fpm restart
service nginx restart
