#!/bin/bash


USERNAME=$(whoami)
HOSTNAME=$(hostname)
SSDUUID=$(sudo smartctl -i /dev/nvme1n1 | grep "Serial Number" | awk '{print $3}')

sed -i "s/foobar/$USERNAME/g" $(grep -rl "foobar" ~/dotfiles)
sed -i "s/3090/$HOSTNAME/g" $(grep -rl "3090" ~/dotfiles)
sed -i "s/S7U6NJ0Y114204N/$SSDUUID/g" $(grep -rl "S7U6NJ0Y114204N" ~/dotfiles)