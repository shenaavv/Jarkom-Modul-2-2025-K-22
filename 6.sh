#!/bin/bash
cat > /etc/bind/db.10.15.43 <<'EOF'
$TTL 86400
@   IN  SOA ns1.K22.com. admin.K22.com. (
        2025101301
        3600
        1800
        604800
        86400 )
    IN  NS  ns1.K22.com.
    IN  NS  ns2.K22.com.
35  IN  PTR sirion.K22.com.
38  IN  PTR lindon.K22.com.
39  IN  PTR vingilot.K22.com.
EOF

echo '
zone "43.15.10.in-addr.arpa" {
    type master;
    file "/etc/bind/db.10.15.43";
    allow-transfer { 192.234.3.4; };
};' >> /etc/bind/named.conf.local

service bind9 restart
