#!/bin/bash

set -e
set -x

# Install the EPEL repository
sudo yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sudo sed -i -e 's/^enabled=1/enabled=0/' /etc/yum.repos.d/epel.repo
# Install the IUS repository (optional)
# sudo yum -y install http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-13.ius.centos7.noarch.rpm

sudo sed -i -e 's,^ACTIVE_CONSOLES=.*$,ACTIVE_CONSOLES=/dev/tty1,' /etc/sysconfig/init

sudo sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sudo yum -y install gcc make gcc-c++ kernel-devel-`uname -r` perl
