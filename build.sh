#!/usr/bin/env bash


################################################################################
# Title: build.sh
# Description: Wrapper script to build a vagrant box using packer and create the Vagrant environment.
# Author: Johandry Amador (johandry@gmail.com)
# Date: 12/01/2014
# Usage: build.sh [-h|--help] distro
################################################################################

#===============================================================================
# Global Variables
#===============================================================================

# Requirements and path of the requirements
declare PACKER=
declare VAGRANT=
declare DOCKER=

# Optional software and path of them
declare BREW=
declare CASK=

# Distro to build
declare DISTRO=

#===============================================================================
# Functions
#===============================================================================

# Print error message in red
error () {
  echo -e "\033[91;1mERROR:\033[0m ${1}"
}

# Print warning message in yellow
warning () {
  echo -e "\033[93;1mWARNING:\033[0m ${1}"
}

# Display help information abut how to use this script
usage () {
  :
}

# Process the options or parameters for this script
process_opt () {
  :
}

# Check requirements for Mac OSX
check_requirements_OSX () {
  PACKER=$(which packer)
  VAGRANT=$(which vagrant)
  DOCKER='NA'
  BREW=$(which brew)
  CASK=$(brew info brew-cask &>/dev/null; echo $?)
  if [[ ${CASK} -eq 0 ]]
    then
    CASK="${BREW} cask"
  else
    CASK=
  fi

  requirements_error=

  if [[ -z "${PACKER}" ]] || [[ -z "${VAGRANT}" ]]
    then
    if [[ -z "${BREW}" ]]
      then
      warning "Brew may be required to install other requirements"
      echo -e "Install Homebrew:"
      echo -e "  ruby -e \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\""
    fi
    if [[ -z "${CASK}" ]]
      then
      warning "Brew Cask may be required to install other requirements"
      echo -e "Install Homebrew Cask:"
      echo -e "  brew install caskroom/cask/brew-cask"
    fi
  fi

  if [[ -z "${PACKER}" ]]
    then
    error "Packer is required."
    echo -e "Install Packer with brew cask:"
    echo -e "  brew cask install packer"
    echo -e "Or install it from https://www.packer.io/downloads.html"
    requirements_error=1
  fi
  if [[ -z "${VAGRANT}" ]]
    then
    error "Vagrant is required"
    echo -e "Install Vagrant with brew cask:"
    echo -e "  brew cask install vagrant"
    echo -e "Or install it form https://www.vagrantup.com/downloads.html"
    requirements_error=1
  fi
  [[ -n "${requirements_error}" ]] && exit 1
}

# Check requirements for Windows (CygWin or MinGW)
check_requirements_Win () {
  PACKER=$(which packer)
  VAGRANT=$(which vagrant)
  DOCKER='NA'

  if [[ -z "${PACKER}" ]]
    then
    error "Packer is required."
    echo -e "Install it from https://www.packer.io/downloads.html"
    requirements_error=1
  fi
  if [[ -z "${VAGRANT}" ]]
    then
    error "Vagrant is required"
    echo -e "Install it form https://www.vagrantup.com/downloads.html"
    requirements_error=1
  fi
  [[ -n "${requirements_error}" ]] && exit 1
}

# Check requirements for Linux
check_requirements_nix () {
  PACKER=$(which packer)
  VAGRANT='NA'
  DOCKER=$(which docker)

  if [[ -z "${PACKER}" ]]
    then
    error "Packer is required."
    echo -e "Install it from https://www.packer.io/downloads.html"
    requirements_error=1
  fi
  if [[ -z "${DOCKER}" ]]
    then
    error "Docker is required"
    echo -e "Install it with apt-get:"
    echo -e " sudo apt-get update & sudo apt-get install docker.io"
    echo -e "Or with yum:"
    echo -e " sudo yum install docker"
    echo -e "Or check instructions from https://docs.docker.com/installation/"
    requirements_error=1
  fi
  [[ -n "${requirements_error}" ]] && exit 1
}

# Identify the OS and check the requirements for it
check_requirements () {
  if [[ "${OSTYPE}" == "linux-gnu" ]]  # Am I on Linux?
    then check_requirements_nix
  elif [[ "${OSTYPE}" == "darwin"* ]]  # Am I on Mac OSX?
    then check_requirements_OSX
  elif [[ "${OSTYPE}" == "cygwin" ]]   # Am I on CygWin?
    then check_requirements_Win
  elif [[ "${OSTYPE}" == "msys" ]]     # Am I on MinGW?
    then check_requirements_Win
  elif [[ "${OSTYPE}" == "freebsd"* ]] # Am I FreeBSD? 
    then check_requirements_nix
  else
    error "Unknown OS Type (${OSTYPE})"
    exit 1
  fi
}

# Build the box for the requested distro using packer
packer_build () {
  :
}

# Build the Vagrant box for the requested distro previously builded with Packer
vagrant_build () {
  :
}

#===============================================================================
# Main code
#===============================================================================

process_opt

check_requirements

packer_build

exit 0
