#!/bin/bash -eux

# Print script message in yellow
message () { 
  echo -e "\033[93;1mSCRIPT:\033[0m ${1}" 
}

message "Reducing active consoles to 1"
sed -i -e 's,^ACTIVE_CONSOLES=.*$,ACTIVE_CONSOLES=/dev/tty1,' /etc/sysconfig/init

message "Cleaning up temporary network addresses"
# Make sure udev doesn't block our network
if grep -q -i "release 6" /etc/redhat-release
  then
  rm -f /etc/udev/rules.d/70-persistent-net.rules
  mkdir /etc/udev/rules.d/70-persistent-net.rules
  rm /lib/udev/rules.d/75-persistent-net-generator.rules
fi

rm -rf /dev/.udev/
if [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ] 
  then
  sed -i "/^HWADDR/d" /etc/sysconfig/network-scripts/ifcfg-eth0
  sed -i "/^UUID/d" /etc/sysconfig/network-scripts/ifcfg-eth0
fi

# New-style network device naming for centos7
if grep -q -i "release 7" /etc/redhat-release 
  then
  # radio off & remove all interface configration
  nmcli radio all off
  /bin/systemctl stop NetworkManager.service
  for ifcfg in `ls /etc/sysconfig/network-scripts/ifcfg-* |grep -v ifcfg-lo` ; do
    rm -f $ifcfg
  done
  rm -rf /var/lib/NetworkManager/*

  message "Setup /etc/rc.d/rc.local for CentOS7"
  cat <<_EOF_ | cat >> /etc/rc.d/rc.local

#VEDEV-BEGIN
LANG=C

# Delete all connection
for con in \`nmcli -t -f uuid con\`; do
  if [ "\$con" != "" ]; then
    nmcli con del \$con
  fi
done

# Add gateway interface connection.
gwdev=\`nmcli dev | grep ethernet | egrep -v 'unmanaged' | head -n 1 | awk '{print \$1}'\`
if [ "\$gwdev" != "" ]; then
  nmcli c add type eth ifname \$gwdev con-name \$gwdev
fi

sed -i -e "/^#VEDEV-BEGIN/,/^#VEDEV-END/{s/^/# /}" /etc/rc.d/rc.local
chmod -x /etc/rc.d/rc.local
#VEDEV-END
_EOF_
  chmod +x /etc/rc.d/rc.local
fi
