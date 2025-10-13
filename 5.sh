#!/bin/bash
echo "valmar" > /etc/hostname
hostname valmar
echo "127.0.1.1 valmar" >> /etc/hosts
ip route add default via 10.15.43.29 2>/dev/null
ip addr add 192.234.3.4/24 dev eth0 2>/dev/null

apt update
apt install -y bind9

cat > /etc/bind/named.conf.local <<'EOF'
zone "K22.com" {
    type slave;
    file "/var/cache/bind/db.K22.com";
    masters { 192.234.3.3; };
};
EOF

service bind9 restart
