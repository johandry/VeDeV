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

* [Packer](http://www.packer.io/): (Required) Used to create the vagrant box.
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

VeDeV have been tested in CygWin on Windows Vista but not in Windows directly.

* [Ruby](https://www.ruby-lang.org/en/): (Required) Programming language used for VeDeV. There are many ways to install it, if you do not have a favorite, you can install it with [RubyInstaller](http://rubyinstaller.org/).
    - Download the installer from http://rubyinstaller.org/downloads/
    - Execute the installer and follow the instructions.

* [Packer](http://packer.io/downloads): (Required) Used to create the vagrant box. 
    - Download the zip for 32-bit or 64-bit from http://packer.io/downloads
    - Create a directory where ever you want and copy the zip file. I use: C:\Workspace\packer
    - Unzip the file in the packer directory
    - Make sure the directory is in your PATH environment variable:
        - Go to: **Control Panel** -> **System** -> **Advanced System Settings** -> **Environment Variables**
        - In **System Variables** search for the **Path** variable
        - Select it and click on **Edit** button.
        - Append to the end __;C:\Workspace\packer__ or the directory where the packer directory is. Make sure you put the semicolon ';' before the packer path as delimiter.
        - Click on **OK** until you exit from all the windows.
        - To test, open a command console and type: packer version
    - If you are using CygWin, make sure the packer directory is in the PATH variable. Edit your profile to include it.

* [VirtualBox](https://www.virtualbox.org/): (Required) Virtualization software or vagrant provider to run the virtual machine.
    - Download the installer for Windows from https://www.virtualbox.org/wiki/Downloads
    - Execute it and follow the instructions.

* [Vagrant](https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.1.msi): (Required) Used to manage the virtual machine.
    - Download the MSI from https://www.vagrantup.com/downloads.html.
    - Execute it and follow the instructions. This installation may take a while.
    - To test, open a command console and type: vagrant --version

* [Vagrant Manager](http://vagrantmanager.com/windows/): (Optional) GUI for Vagrant. It is optional but would be nice to have it.
    - Download the latest version from http://vagrantmanager.com/downloads/ or https://github.com/lanayotech/vagrant-manager-windows/releases
    - Execute the installer and follow the instructions.

### Linux

VeDeV purpose is to be used in Mac OS X and Windows to build, ship and deploy the projects with Docker using a Linux box. If you are using Linux then use Docker directly or other such as Puppet, Chef or Salt.

## Usage

Install all the requirements for your OS. See the requirements and instructions above.

Clone the repository:

    $ git clone https://github.com/johandry/vedev && cd vedev && bundle

List the available packer templates to build a box:

    $ ./vedev list build

Build a machine image from the template in the repository, there is no need to write the entire name of the distro:

    $ ./vedev build ubuntu-14.1

When you finish, you may clean the packer box with:

    $ ./vedev clean box ubuntu-14.1

Or, you may delete the packer cache or the vagrant environment with the options 'clean cache' and 'clean vagrant'. Or clean it all with 'clean all'.

Check the VeDeV help for more details.

    $ ./vedev help

When the build is ready you can test it with:

    $ ./vedev test ubuntu-14.1

Or, go to the vagrant machine directory and run 'rake':

    $ cd build/ubuntu-14.1* && rake

You can create more ServerSpecs adding specs files in the specs directory. For example, do some database testing with: build/ubuntu-14.1*/spec/database_spec.rb

If the test is success you can login to the vagrant box with:

    $ ./vedev start ubuntu-14.1

When you finish, you can stop/halt all the machines or just one with:

    $ ./vedev stop ubuntu-14.1

The environment is ready to use it for your development environment, provision it using Docker, Puppet or a simple Shell Script and to add more tests with ServerSpec. Just copy the directory of the vagrant machine inside build, for example build/ubuntu-14.1*, to the development project directory.

## Tasks

- [X] **Testing**: Create a Rake file using ServerSpec to test.
- [ ] **Push to Atlas**: Once the Vagrant box is ready upload it to Altas (previously VagrantCloud). This is not possible yet. Waiting for Atlas to provide (free) packer push of vagrant-virtualbox boxes.
- [X] **Options**: Add more options to vedev such as update, init; and improve clean and build options.
- [X] **More Options**: Add more options to vedev such as up and down, to vagrant up && ssh and vagrant halt.
- [ ] **Official Boxes**: Allow to use an existing box on Atlas or in the cloud instead of creating your own box.
- [ ] **AWS**: Add Amazon Web Services as provider.
- [ ] **CoreOS**: Add CoreOS in the list of Linux distributions.

## Why VeDeV?

1. I use to develop the same project in Mac OS or Windows (CygWin). VeDeV help me to have a virtual box, a single development environment, no matter what OS I am using.
2. Allows me to test my application in several Linux machines.
3. I can re-build the environment when there is a new version or packages update. Don't waste time during the provisioning, updating the vagrant machine.
4. We can use Docker on any Linux, including some light ones, but VeDeV allow me to use Docker on several 'heavy' and powerful Linux OS with no limitation of resources.
5. The idea is to use Docker as provisioner for a development project but with VeDeV I can switch from Docker to Puppet or any other provisioner, using a powerful Linux OS.

## Thanks

The creation of the packer templates, scripts and http templates are based on several github projects. This is a project I used to learn packer and I thanks to all those developers that publish their work. 

In the same way, every body is free to use what I did to improve it or learn from it.

If you find an error, please, open a [Github Issue](https://github.com/johandry/vedev/issues).