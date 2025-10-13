#!/bin/bash
cat > /etc/resolv.conf <<EOF
nameserver 192.234.3.3
nameserver 192.234.3.4
nameserver 192.168.122.1
EOF
