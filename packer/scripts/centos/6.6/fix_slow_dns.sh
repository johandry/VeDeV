#!/bin/bash

set -e
set -x

## https://access.redhat.com/site/solutions/58625 (subscription required)
# add 'single-request-reopen' so it is included when /etc/resolv.conf is generated
echo 'RES_OPTIONS="single-request-reopen"' >> /etc/sysconfig/network
service network restart
echo 'Slow DNS fix applied (single-request-reopen)'