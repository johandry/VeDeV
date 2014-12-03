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

# Script name and directory
declare -r SCRIPT_NAME=${0##*/}
declare -r SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

# Options
declare DEBUG=
declare ACTION=

#===============================================================================
# Functions
#===============================================================================

# Print error message in red
error () {
  echo -e "\033[91;1mERROR:\033[0m ${1}" >&2
}

# Print warning message in yellow
warning () {
  echo -e "\033[93;1mWARNING:\033[0m ${1}"
}

# Display help information abut how to use this script
usage () {
  cat<<-EOH
${SCRIPT_NAME} [-v] -h | -c { all | box | cache | vagrant} | -l | distro
where:
  -h: Help. Print this information
  -v: Verbose. Show more details when the script is executed. Useful for debugging
  -l: List distributions available to build.
  -c: Clean. Move to the trash directory the boxes, packer cache, vagrant boxes or all.
  -b: Build a Linux Distribution. Could be the full name or partial but if should not match with more than one.
EOH
}

# Check if the distro exists or if there are more than one with that name
check_distro () {
  json="${SCRIPT_DIR}/packer/templates/${DISTRO}*.json"
  json=$(echo $json | sed "s|${SCRIPT_DIR}/packer/templates/||g" | sed 's/\.json//g')
  count=$(echo ${json} | wc -w | sed 's/ //g')
  if [[ ${count} -gt 1 ]]
    then
    error "There are $count distros with the name '${DISTRO}'. Specify which one you want to build."
    for j in ${json}
    do
      echo "  * $j"
    done
    exit 1
  fi
  DISTRO=${json}
}

# List all the available distros to build
list_distros () {
  json="${SCRIPT_DIR}/packer/templates/*.json"
  json=$(echo $json | sed "s|${SCRIPT_DIR}/packer/templates/||g" | sed 's/\.json//g')
  for distro in ${json}
  do
    echo "  * ${distro}"
  done
}

clean_boxes () {
  [[ ! -f "${SCRIPT_DIR}"/vagrant/boxes/*.box ]] && echo "No boxes to clean" && return
  d=$(date +%Y%m%d)
  warning "Moving $(\ls -1 ${SCRIPT_DIR}/vagrant/boxes/*.box | wc -l | sed 's/ //g') boxes to Trash/${d}/boxes"
  mkdir -p "${SCRIPT_DIR}/Trash/${d}"
  mv -f "${SCRIPT_DIR}"/vagrant/boxes/ "${SCRIPT_DIR}"/Trash/${d}/
  echo
}

clean_cache () {
  [[ ! -d "${SCRIPT_DIR}"/packer_cache ]] && echo "No packer cache to clean" && return
  d=$(date +%Y%m%d)
  warning "Moving Packer Cache to Trash/${d}"
  mkdir -p "${SCRIPT_DIR}/Trash/${d}"
  mv -f "${SCRIPT_DIR}"/packer_cache "${SCRIPT_DIR}"/Trash/${d}/
  echo
}

# Move to trash every box and remove every vagrant environment created.
clean_vagrant() {
  total=$(${VAGRANT} box list | grep -v 'no installed boxes' | wc -l | sed 's/ //g')
  count=0
  if [[ -d "${SCRIPT_DIR}"/vagrant ]]
    then
    count=$(\ls -1d "${SCRIPT_DIR}"/vagrant/* | grep -v boxes | wc -l | sed 's/ //g')
    if [[ ${count} -ne 0 ]]
      then
      d=$(date +%Y%m%d)
      mkdir -p "${SCRIPT_DIR}/Trash/${d}"
      for box in "${SCRIPT_DIR}"/vagrant/*
      do
        if [[ -e ${box} && ${box} != "${SCRIPT_DIR}"/vagrant/boxes ]]
          then
          old_PWD=$(pwd)
          cd ${box}
          warning "Destroying vagrant box 'vagrant-${box##*/}'"
          ${VAGRANT} destroy -f
          warning "Removing vagrant box 'vagrant-${box##*/}'"
          ${VAGRANT} box remove vagrant-${box##*/}
          warning "Moving vagrant box 'vagrant-${box##*/}' to Trash/${d}"
          mv -f "${box}" "${SCRIPT_DIR}"/Trash/${d}/
          cd ${old_PWD}
        fi
      done
      echo
    fi
  fi
  echo "Removed ${count}/${total} vagrant boxes"
  echo
}

clean_all () {
  clean_cache
  clean_boxes
  clean_vagrant
}

# Process the options or parameters for this script
process_opt () {
  [[ $# -eq 0 ]] && usage && exit 1

  declare -r options=":hvlc:"

  while getopts "${options}" opt; do
    case "${opt}" in
      h)
        usage
        exit 0
        ;;
      v)
        DEBUG=1
        ;;
      l)
        list_distros
        exit 0
        ;;
      c)
        case ${OPTARG} in
          box)
            ACTION=clean_boxes
            ;;
          cache)
            ACTION=clean_cache
            ;;
          vagrant)
            ACTION=clean_vagrant
            ;;
          all)
            ACTION=clean_all
            ;;
          \?)
            error "Invalid argument '-${OPTARG}'. Clean options could be: box, cache, vagrant and all"
            usage
            exit 1
            ;;
          esac
          ;;
      \?)
        error "Invalid argument '-${OPTARG}'"
        usage
        exit 1
        ;;
      *)
        usage
        exit 0
        ;;
    esac
  done
  shift $((OPTIND-1))
  
  if [[ -z ${ACTION} ]]
    then
    [[ $# -eq 0 ]] && error "No distro provided" && usage && exit 1
    DISTRO="${1}"
    check_distro
    ACTION=build
  fi
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
  echo "Building box for ${DISTRO}"
  echo
  ${PACKER} build "${SCRIPT_DIR}/packer/templates/${DISTRO}.json"
}

# Build the Vagrant box for the requested distro previously builded with Packer
vagrant_build () {
  echo "Creating vagrant environment"
  echo
  ${VAGRANT} box add "vagrant-${DISTRO}" "${SCRIPT_DIR}/vagrant/boxes/${DISTRO}.box"
  old_PWD=$(pwd)
  mkdir -p "${SCRIPT_DIR}/vagrant/${DISTRO}" && cd "${SCRIPT_DIR}/vagrant/${DISTRO}"
  ${VAGRANT} init "vagrant-${DISTRO}"
  ${VAGRANT} up
  cd ${old_PWD}
}

#===============================================================================
# Main code
#===============================================================================

process_opt "$@"  # Process the parameters

check_requirements # Check if the required software exists and take their full path

if [[ ${ACTION} == "build" ]] # then build the packer box and the vagrant box
  then
  packer_build
  vagrant_build
elif [[ -n ${ACTION} ]] # if there is an action, execute it. This will be a clean funciton
  then
  ${ACTION}
fi

exit 0
