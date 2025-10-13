#!/bin/bash
apt update && apt install iptables -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.222.0.0/16