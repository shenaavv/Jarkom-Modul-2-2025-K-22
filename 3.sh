#!/bin/bash
apt update && apt install iptables -y
echo nameserver 192.168.122.1 > /etc/resolv.conf