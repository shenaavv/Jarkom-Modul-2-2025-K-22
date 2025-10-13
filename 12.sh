#!/bin/bash
apt-get install apache2-utils -y
apt install nginx -y
htpasswd -c /etc/nginx/.htpasswd admin 
cat /etc/nginx/.htpasswd 
nano /etc/nginx/sites-available/default
service nginx restart
service nginx status