#!/bin/bash

set -e
set -x

sudo yum -y install docker
sudo chkconfig docker on