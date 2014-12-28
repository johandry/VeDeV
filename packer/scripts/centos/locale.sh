#!/bin/bash -eux

# Print script message in yellow
message () { 
  echo -e "\033[93;1mSCRIPT:\033[0m ${1}" 
}

message "Removing locales but en_US"
localedef --list-archive | grep -a -v en_US.utf8 | xargs localedef --delete-from-archive
cp /usr/lib/locale/locale-archive{,.tmpl}
build-locale-archive
