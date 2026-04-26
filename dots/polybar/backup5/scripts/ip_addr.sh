#!/bin/bash
ip=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'src \K\S+')
[ -z "$ip" ] && ip="no ip"
echo "$ip"
