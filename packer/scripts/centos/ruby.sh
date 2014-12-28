#!/bin/bash -eux

# Print script message in yellow
message () { 
  echo -e "\033[93;1mSCRIPT:\033[0m ${1}" 
}

message "Installing ruby"
yum -y install ruby

# Install ruby dependencies
yum -y install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel

# Install doc and devel
yum -y install ruby-rdoc ruby-devel

# Install rubygems
yum -y install rubygems