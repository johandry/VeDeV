#!/bin/bash -eux

# Print script message in yellow
message () { 
  echo -e "\033[93;1mSCRIPT:\033[0m ${1}" 
}

message "Installing docker"
cat /etc/redhat-release
if grep -q -i "release 7" /etc/redhat-release ; then
    yum install -y docker
elif grep -q -i "release 6" /etc/redhat-release ; then
    yum install -y docker-io
fi

message "Starting docker"
service docker start

message "Enabling docker to start on reboot"
chkconfig docker on