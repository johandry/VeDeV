# VeDeV: Virtual Environment for Development

[![Build Status](http://img.shields.io/travis/johandry/vedev.svg)][travis]
[travis]: https://travis-ci.org/johandry/vedev

Create a Virtual Environment for Development for OS X and Windows. Uses [Packer](http://www.packer.io/) to create the Vagrant Box, [Vagrant](https://www.vagrantup.com/) to manage the virtual machine, [VirtualBox](https://www.virtualbox.org/) as the virtualization software, Scripts to provision the new box and [Docker](https://www.docker.com/) to build, ship and run the developed application.

As Docker require a virtual machine manager in OS X and Windows, VeDeV use Vagrant for this purpose. Instead of use a pre-build and shared box, you can create your own with Packer using what ever OS you like with the same requirements for the developed application. In case you are using Linux then ignore Vagrant and VirtualBox, and use Docker directly. 

The initial provisioning of the box is done with shell scripts on Packer. Later you can provision the box with shell or Puppet on Vagrant. The project requirements can be provisioned with Docker.

The only Linux distros available to create a box are: 
* CentOS 6.6
* CentOS 7.0
* Ubuntu 14.04.1
* Ubuntu 14.10

These are the only I need, so far, but I can add more in the future. They are minimal boxes with **Docker** and **Ruby** installed.

## Requirements

### Mac OS X

* [Homebrew](http://brew.sh/): (Optional) Used to install all Brew-Cask and this to install all the main requirements. If not used, Homebrew Cask is not required and the required software will be installed manually.
    ```bash
    $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ```

* [Homebrew Cask](http://caskroom.io/): (Optional) Used to install all the requirements. If not used, the required software will be installed manually.
    ```bash
    $ brew install caskroom/cask/brew-cask
    ```

* [Packer](http://www.packer.io/): (Required) Used to create the vagrant box. Or, to create the Docker image if you are using Linux.
    ```bash
    $ brew cask install packer
    ```

* [Vagrant](https://www.vagrantup.com/): (Required) Used to manage the virtual machine.
    ```bash
    $ brew cask install vagrant
    ```

* [VirtualBox](https://www.virtualbox.org/): (Required) Virtualization software to run the virtual machine.
    ```bash
    $ brew cask install virtualbox
    ```

* [Vagrant Manager](http://vagrantmanager.com/): (Optional) GUI for Vagrant. It is optional but would be nice to have it.
    ```bash
    $ brew cask install vagrant-manager
    ```
    
### Windows

_TODO_

### Linux

VeDeV purpose is to be used in Mac OS X and Windows to build, ship and deploy the projects with Docker using a Linux box. If you are using Linux then use Docker directly or other such as Puppet, Chef or Salt.

## Usage

Clone the repository:

    $ git clone https://github.com/johandry/vedev && cd vedev

List the available packer templates to build a box:

    $ ./vedev.rb list build

Build a machine image from the template in the repository, there is no need to write the entire name of the distro:

    $ ./vedev.rb build ubuntu-14.1

When you finish, you may clean the packer box with:

    $ ./vedev.rb clean box ubuntu-14.1

Or, you may delete the packer cache or the vagrant environment with the options 'clean cache' and 'clean vagrant'. Or clean it all with 'clean all'.

Check the VeDeV help for more details.

    $ ./vedev.rb help

When the build is ready you can login to the vagrant box with:

    $ cd vagrant/ubuntu-14.1* && vagrant up && vagrant ssh

## Tasks

- [ ] **Testing**: Create a Rake file using ServerSpec to test.
- [ ] **Push to Atlas**: Once the Vagrant box is ready upload it to Altas (previously VagrantCloud)
- [X] **Options**: Add more options to vedev.rb such as update, init; and improve clean and build options.
- [ ] **More Options**: Add more options to vedev.rb such as up and down, to vagrant up && ssh and vagrant halt.

## Thanks

The creation of the packer templates, scripts and http templates are based on several github projects. This is a project I used to learn packer and I thanks to all the developers that publish their work. 

In the same way, every body is free to use what I did to improve it or learn.