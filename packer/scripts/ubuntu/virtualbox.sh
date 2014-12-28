#!/bin/bash -eux

# Print script message in yellow
message () { 
  echo -e "\033[93;1mSCRIPT:\033[0m ${1}" 
}

message "Installing VirtualBox guest additions"
aptitude -y install dkms
aptitude -y install make

# Uncomment this if you want to install Guest Additions with support for X
# aptitude -y install xserver-xorg

mount -o loop,ro ~/VBoxGuestAdditions.iso /mnt/
/mnt/VBoxLinuxAdditions.run || :
umount /mnt/
rm -f ~/VBoxGuestAdditions.iso

VBOX_VERSION=$(cat ~/.vbox_version)
if [ "$VBOX_VERSION" == '4.3.10' ]; then
  # https://www.virtualbox.org/ticket/12879
  fln -s "/opt/VBoxGuestAdditions-$VBOX_VERSION/lib/VBoxGuestAdditions" /usr/lib/VBoxGuestAdditions
fi
