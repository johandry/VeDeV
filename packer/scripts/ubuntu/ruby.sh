#!/bin/bash

set -e
set -x

# Install dependencies
sudo aptitude -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties

# Install ruby ruby-dev and doc
sudo aptitude -y install ruby ruby-dev ri