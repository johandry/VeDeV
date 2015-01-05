#!/bin/bash -eux

# Print script message in yellow
message () { 
  echo -e "\033[93;1mSCRIPT:\033[0m ${1}" 
}

# Should this be installed and continue a minimal installation?
message "Installing Development tools"
yum -y groupinstall "Development Tools"

message "Installing ruby"
# Centos 6.6 have ruby 1.8, upgrade it to the latest version.
if grep -q -i "release 6" /etc/redhat-release
  then
  # Remove ruby, if any
  yum remove -y ruby ruby-devel

  # Install ruby dependencies
  yum -y install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel

  # Install ruby latest version (2.1.5)
  # Update URL if ruby latest version change
  wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz
  tar xvfvz ruby-*.tar.gz
  chown -R root.root ruby-* && cd ruby-* && ./configure && make && make install

  else
  yum -y install ruby

  # Install ruby dependencies
  yum -y install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel

  # Install doc and devel
  yum -y install ruby-rdoc ruby-devel

  # Install rubygems
  yum -y install rubygems
fi

# message "Updating Gems"
# # Upgrading rubugem and gems. Gems as vagrant, not as root.

# gem update --system
# su - vagrant -c "gem install bundler"
# su - vagrant -c "gem update"
