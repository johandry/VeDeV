#!/bin/bash

set -e
set -x

sudo yum -y install bzip2
sudo yum -y --enablerepo=epel install dkms
sudo yum -y install kernel-devel
sudo yum -y install make
sudo yum -y install perl

# Uncomment this if you want to install Guest Additions with support for X
#sudo yum -y install xorg-x11-server-Xorg

sudo mount -o loop,ro ~/VBoxGuestAdditions.iso /mnt/
sudo /mnt/VBoxLinuxAdditions.run || :
sudo umount /mnt/
rm -f ~/VBoxGuestAdditions.iso