#!/bin/bash -eux

# Print script message in yellow
message () { 
  echo -e "\033[93;1mSCRIPT:\033[0m ${1}" 
}

message "Adding EPEL repo"
cat /etc/redhat-release
if grep -q -i "release 7" /etc/redhat-release ; then
    wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
    rpm -Uvh epel-release-7*.rpm
    rm -f epel-release-7*.rpm
    # yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
    # Install the IUS repository (optional)
    # yum -y install http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-13.ius.centos7.noarch.rpm
elif grep -q -i "release 6" /etc/redhat-release ; then
    # wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    # rpm -Uvh epel-release-6*.rpm
    yum -y install https://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
fi

# sudo sed -i -e 's/^enabled=1/enabled=0/' /etc/yum.repos.d/epel.repo
