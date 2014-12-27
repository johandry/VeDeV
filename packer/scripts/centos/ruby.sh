#!/bin/bash

set -e
set -x

sudo yum -y install ruby

# Install ruby dependencies
sudo yum -y install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel

# Install doc and devel
sudo yum -y install ruby-rdoc ruby-devel

# Install rubygems
sudo yum -y install rubygems