#!/bin/bash -eux

# Print script message in yellow
message () { 
  echo -e "\033[93;1mSCRIPT:\033[0m ${1}" 
}

message "Setting one active console"
sed -i -e 's,^\(ACTIVE_CONSOLES="/dev/tty\).*,\11",' /etc/default/console-setup
for f in /etc/init/tty[^1]*.conf; do
  mv "$f"{,.bak}
done
