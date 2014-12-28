#!/bin/bash -eux

# Print script message in yellow
message () { 
  echo -e "\033[93;1mSCRIPT:\033[0m ${1}" 
}

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
  message "Installing VirtualBox guest additions"
  # Assume that we've installed all the prerequisites:
  # kernel-headers-$(uname -r) kernel-devel-$(uname -r) gcc make perl
  # from the install media via ks.cfg
  #
  # If not:
  # yum -y --enablerepo=epel install dkms
  # yum -y install bzip2 kernel-devel make perl
  #
  # If you want to install Guest Additions with support for X
  # yum -y install xorg-x11-server-Xorg
  # And remove --nox11 parameter below

  sudo mount -o loop,ro /home/vagrant/VBoxGuestAdditions.iso /mnt/
  sudo /mnt/VBoxLinuxAdditions.run --nox11 || :
  sudo umount /mnt/
  rm -f /home/vagrant/VBoxGuestAdditions.iso
fi
