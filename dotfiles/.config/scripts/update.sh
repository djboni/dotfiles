#!/bin/sh
set -xe

sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean -y

sudo systemctl start snapd.service
sudo snap refresh
sudo systemctl stop snapd.service
