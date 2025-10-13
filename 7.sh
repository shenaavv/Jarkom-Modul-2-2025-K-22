#!/bin/bash
echo '
zone "43.15.10.in-addr.arpa" {
    type slave;
    file "/var/cache/bind/db.10.15.43";
    masters { 192.234.3.3; };
};' >> /etc/bind/named.conf.local

service bind9 restart
