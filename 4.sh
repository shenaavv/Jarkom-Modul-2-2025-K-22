#!/bin/bash
echo "tirion" > /etc/hostname
hostname tirion
echo "127.0.1.1 tirion" >> /etc/hosts
ip route add default via 10.15.43.29 2>/dev/null
ip addr add 192.234.3.3/24 dev eth0 2>/dev/null

apt update
apt install -y bind9

cat > /etc/bind/db.K22.com <<'EOF'
$TTL 86400
@   IN  SOA ns1.K22.com. admin.K22.com. (
        2025101301
        3600
        1800
        604800
        86400 )
    IN  NS  ns1.K22.com.
    IN  NS  ns2.K22.com.
ns1 IN  A   192.234.3.3
ns2 IN  A   192.234.3.4
@   IN  A   10.15.43.35
www     IN  CNAME   sirion
static  IN  CNAME   lindon
app     IN  CNAME   vingilot
sirion   IN  A   10.15.43.35
lindon   IN  A   10.15.43.38
vingilot IN  A   10.15.43.39
EOF

cat > /etc/bind/named.conf.local <<'EOF'
zone "K22.com" {
    type master;
    file "/etc/bind/db.K22.com";
    allow-transfer { 192.234.3.4; };
    notify yes;
};
EOF

service bind9 restart
