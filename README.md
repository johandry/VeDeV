# vedev: Virtual Environment for Development

This is a project in development, it is not ready yet.

Create a Virtual Environment for Develoment for OS X and Windows using [Packer](http://www.packer.io/) to create the Vagrant Box, [Vagrant](https://www.vagrantup.com/) to manage the virtual machine, [VirtualBox](https://www.virtualbox.org/) as the virtualization software, [Puppet](http://puppetlabs.com/) to provision the new box and [Docker](https://www.docker.com/) to build, ship and run the developed application.

As Docker require a virtual machine manager in OS X and Windows, vedev use Vagrant for this purpose. Instead of use a pre-build and shared box, you can create your own with Packer using what ever OS you like with the same requirements for the developed application. In case you are using Linux it is possible to skip Vagrant and VirtualBox to use Docker. The initial provisioning of the box is done with shell scripts and Puppet.

## Requirements

### Mac OS X

[Homebrew](http://brew.sh/): (Optional) Used to install all Brew-Cask and this to install all the main requirements. If not used, Homebrew Cask is not required and the required software will be installed manually.

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

[Homebrew Cask](http://caskroom.io/): (Optional) Used to install all the requirements. If not used, the required software will be installed manually.

brew install caskroom/cask/brew-cask

[Packer](http://www.packer.io/): (Required) Used to create the vagrant box. Or, to create the Docker image if you are using Linux.

brew cask install packer

[Vagrant](https://www.vagrantup.com/): (Required) Used to manage the virtual machine.

brew cask install vagrant

[VirtualBox](https://www.virtualbox.org/): (Required) Virtualization software to run the virtual machine.

brew cask virtualbox

[Vagrant Manager](http://vagrantmanager.com/): (Optional) GUI for Vagrant. It is optional but would be nice to have it.

brew cask vagrant-manager

[Docker](https://www.docker.com/): (Required) Used to build, ship and run the developed application.

TODO

[Puppet](http://puppetlabs.com/): (Required) Used to provision the new vagrant box. Puppet and Shell scripts will do the initial and base provisioning.

TODO

### Windows

TODO

## Packer Templates

The only packer templates and provisionong scripts are for CentOS 6.5 and Ubuntu 14. They were obtained from https://github.com/kaorimatz/packer-templates but there are lot of packer templates in GitHub. These are the only OS I need now but more would be added.

## Usage

Clone the repository:

    $ git clone https://github.com/johandry/vedev && cd vedev

Build a machine image from the template in the repository:

    $ packer build packer/templates/ubuntu-14.10-amd64.json

## Configuration

You can configure each template to match your requirements by setting the following [user variables](https://packer.io/docs/templates/user-variables.html).

 User Variable      | Default Value | Description
--------------------|---------------|----------------------------------------------------------------------------------------
 `compressin_level` | 6             | [Documentation](https://packer.io/docs/post-processors/vagrant.html#compression_level)
 `cpus`             | 1             | Number of CPUs
 `disk_size`        | 40000         | [Documentation](https://packer.io/docs/builders/virtualbox-iso.html#disk_size)
 `headless`         | 0             | [Documentation](https://packer.io/docs/builders/virtualbox-iso.html#headless)
 `memory`           | 512           | Memory size in MB
 `mirror`           |               | A URL of the mirror where the ISO image is available
