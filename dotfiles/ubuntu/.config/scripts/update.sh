#!/bin/bash
set -xe

sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

if which snap; then
    sudo systemctl start snapd.service
    sudo snap refresh
    sudo systemctl stop snapd.service
fid
