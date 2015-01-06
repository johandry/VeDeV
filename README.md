# VeDeV: Virtual Environment for Development

[![Build Status](http://img.shields.io/travis/johandry/vedev.svg)][travis]
[travis]: https://travis-ci.org/johandry/vedev

VeDeV can be used on OS X and Windows to create a Linux Virtual Environment for Development with a simple command. This virtual environment is used to build, ship and run the developed application with any provisioner such as [Docker](https://www.docker.com/), Puppet, Chef, Salt or a simple script.

It uses [Packer](http://www.packer.io/) to create the Vagrant box that is provisioned with Shell Scrips and [Vagrant](https://www.vagrantup.com/) to manage the virtual machine using [VirtualBox](https://www.virtualbox.org/) as provider. It also test the created machines with [ServerSpec](http://serverspec.org/). The result is a minimal machine with **Docker** and **Ruby** installed that you can move to your project directory.

The only Linux distributions available to create a box are: 
* CentOS 6.6
* CentOS 7.0
* Ubuntu 14.04.1
* Ubuntu 14.10

More will be included.

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

* [VirtualBox](https://www.virtualbox.org/): (Required) Virtualization software or vagrant provider to run the virtual machine.
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

Install all the requirements for your OS. See the requirements and instructions above.

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

When the build is ready you can test it with:

    $ ./vedev.rb test ubuntu-14.1

Or, go to the vagrant machine directory and run 'rake':

    $ cd build/ubuntu-14.1* && rake

You can create more ServerSpecs adding specs files in the specs directory. For example, do some database testing with: build/ubuntu-14.1*/spec/database_spec.rb

If the test is success you can login to the vagrant box with:

    $ ./vedev.rb start ubuntu-14.1

When you finish, you can stop/halt all the machines or just one with:

    $ ./vedev.rb stop ubuntu-14.1

The environment is ready to use it for your development environment, provision it using Docker, Puppet or a simple Shell Script and to add more tests with ServerSpec. Just copy the directory of the vagrant machine inside build, for example build/ubuntu-14.1*, to the development project directory.

## Tasks

- [X] **Testing**: Create a Rake file using ServerSpec to test.
- [ ] **Push to Atlas**: Once the Vagrant box is ready upload it to Altas (previously VagrantCloud). This is not possible yet. Waiting for Atlas to provide (free) packer push of vagrant-virtualbox boxes.
- [X] **Options**: Add more options to vedev.rb such as update, init; and improve clean and build options.
- [X] **More Options**: Add more options to vedev.rb such as up and down, to vagrant up && ssh and vagrant halt.
- [ ] **Official Boxes**: Allow to use an existing box on Atlas or in the cloud instead of creating your own box.

## Why VeDeV?

1. I use to develop the same project in Mac OS or Windows (CygWin). VeDeV help me to have a virtual box, a single development environment, no matter what OS I am using.
2. Allows me to test my application in several Linux machines.
3. I can re-build the environment when there is a new version or packages update. Don't waste time during the provisioning, updating the vagrant machine.
4. With Docker we can use any Linux, including some light ones, but this allow me to use Docker, Puppet or any provisioner on several 'heavy' and powerful Linux OS.

## Thanks

The creation of the packer templates, scripts and http templates are based on several github projects. This is a project I used to learn packer and I thanks to all those developers that publish their work. 

In the same way, every body is free to use what I did to improve it or learn from it.