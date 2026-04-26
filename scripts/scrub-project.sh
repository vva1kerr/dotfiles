#!/bin/bash


USERNAME=$(whoami)
HOSTNAME=$(hostname)
SSDUUID=$(sudo smartctl -i /dev/nvme1n1 | grep "Serial Number" | awk '{print $3}')

sed -i "s/$USERNAME/foobar/g" $(grep -rl "$USERNAME" ~/dotfiles)
sed -i "s/$HOSTNAME/3090/g" $(grep -rl "$HOSTNAME" ~/dotfiles)
sed -i "s/$SSDUUID/S7U6NJ0Y114204N/g" $(grep -rl "$SSDUUID" ~/dotfiles)