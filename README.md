# vedev: Virtual Environment for Development

This is a project in development, it is not ready yet.

Create a Virtual Environment for Develoment for OS X and Windows. Uses [Packer](http://www.packer.io/) to create the Vagrant Box, [Vagrant](https://www.vagrantup.com/) to manage the virtual machine, [VirtualBox](https://www.virtualbox.org/) as the virtualization software, [Puppet](http://puppetlabs.com/) and Shell Scripts to provision the new box and [Docker](https://www.docker.com/) to build, ship and run the developed application.

As Docker require a virtual machine manager in OS X and Windows, vedev use Vagrant for this purpose. Instead of use a pre-build and shared box, you can create your own with Packer using what ever OS you like with the same requirements for the developed application. In case you are using Linux it is possible to skip Vagrant and VirtualBox to use Docker. The initial provisioning of the box is done with shell scripts and Puppet.

## Requirements

### Mac OS X

* [Homebrew](http://brew.sh/): (Optional) Used to install all Brew-Cask and this to install all the main requirements. If not used, Homebrew Cask is not required and the required software will be installed manually.

    $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

* [Homebrew Cask](http://caskroom.io/): (Optional) Used to install all the requirements. If not used, the required software will be installed manually.

    $ brew install caskroom/cask/brew-cask

* [Packer](http://www.packer.io/): (Required) Used to create the vagrant box. Or, to create the Docker image if you are using Linux.

    $ brew cask install packer

* [Vagrant](https://www.vagrantup.com/): (Required) Used to manage the virtual machine.

    $ brew cask install vagrant

* [VirtualBox](https://www.virtualbox.org/): (Required) Virtualization software to run the virtual machine.

    $ brew cask install virtualbox

* [Vagrant Manager](http://vagrantmanager.com/): (Optional) GUI for Vagrant. It is optional but would be nice to have it.

    $ brew cask install vagrant-manager

* [Docker](https://www.docker.com/): (Required) Used to build, ship and run the developed application.

TODO

* [Puppet](http://puppetlabs.com/): (Required) Used to provision the new vagrant box. Puppet and Shell scripts will do the initial and base provisioning.

TODO

### Windows

TODO

## Usage

Clone the repository:

    $ git clone https://github.com/johandry/vedev && cd vedev

Build a machine image from the template in the repository:

    $ ./vedev.rb build ubuntu-14.1

To know the available packer templates to build run this:

    $ ./vedev.rb list

When you finish, you may clean the packer box with:

    $ ./vedev.rb clean box

Or, you may delete the packer cache or the vagrant environment with the options 'cache' and 'vagrant'. Or clean it all with option 'all'.

Check the build.sh help for more details.

    $ ./vedev.rb help

When the build is ready you can login to the vagrant box with:

    $ cd vagrant/ubuntu-14.1* && vagrant ssh

