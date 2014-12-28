#!/bin/bash -eux

# Print script message in yellow
message () { 
  echo -e "\033[93;1mSCRIPT:\033[0m ${1}" 
}

message "Removing packages for the kernel"
if rpm -q --whatprovides kernel | grep -Fqv $(uname -r); then
  rpm -q --whatprovides kernel | grep -Fv $(uname -r) | xargs yum -y remove
fi

message "Cleaning up yum cache of metadata and packages to save space"
yum -y clean all
yum --enablerepo=epel clean all

message "Cleaning up the yum history and logs"
yum history new
truncate -c -s 0 /var/log/yum.log

message "Removing temporary files used to build box"
rm -rf /tmp/*
