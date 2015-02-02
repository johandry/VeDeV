# VeDeV: Virtual Environment for Development

[![Build Status](http://img.shields.io/travis/johandry/VeDeV.svg)][travis]
[travis]: https://travis-ci.org/johandry/VeDeV

VeDeV can be used on OS X and Windows to create a Linux Virtual Environment for Development with a simple command. This virtual environment is used to build, ship and run the developed application with any provisioner such as [Docker](https://www.docker.com/), Puppet, Chef, Salt or a simple script.

VeDeV is a project to integrate Packer, Vagrant & Docker. It uses [Packer](http://www.packer.io/) to create the Vagrant box that is provisioned with Shell Scrips and [Vagrant](https://www.vagrantup.com/) to manage the virtual machine using [VirtualBox](https://www.virtualbox.org/) as provider. It also test the created machines with [ServerSpec](http://serverspec.org/). The result is a minimal machine with **Docker** and **Ruby** installed that you can move to your project directory.

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
    
### CygWin on Windows

VeDeV have been tested on CygWin for Windows Vista 64-bits. These instructions may help with other Linux emulator for Windows or on Windows itself.

* [Ruby](https://www.ruby-lang.org/en/): (Required) Programming language used for VeDeV. In CygWin make sure you install ruby and bundle. On Windows there are many ways to install it, if you do not have a favorite, you can install it with [RubyInstaller](http://rubyinstaller.org/).
    - Download the installer from http://rubyinstaller.org/downloads/
    - Execute the installer and follow the instructions.

* [Packer](http://packer.io/downloads): (Required) Used to create the vagrant box. 
    In CygWin execute these:
    ```bash
    # Check the latest version of Packer for Windows in http://packer.io/downloads

    $ cd /usr/local/bin
    $ wget -O packer.zip https://dl.bintray.com/mitchellh/packer/packer_0.7.5_windows_amd64.zip
    $ unzip packer.zip
    $ rm packer.zip

    # Testing
    $ packer version
    ```
    On Windows follow these instructions:
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

Clone the repository and update/install the required gems:

    $ git clone https://github.com/johandry/vedev && cd vedev && bundle

List the available packer templates to build a box:

    $ ./vedev list build

Build a machine image from the template in the repository, there is no need to write the entire name of the distro:

    $ ./vedev build ubuntu-14.1

Check the VeDeV help for more details.

    $ ./vedev help

When the build is ready you can test it with:

    $ ./vedev test ubuntu-14.1

Or, go to the vagrant machine directory and run 'rake':

    $ cd build/ubuntu-14.1* && rake

You can create more ServerSpecs adding specs files in the specs directory, make sure the spec test file ends with _spec.rb. For example, do some database testing with: build/ubuntu-14.1*/spec/database_spec.rb

If the test is success you can login to the vagrant box with:

    $ ./vedev start ubuntu-14.1

When you finish, you can stop/halt all the machines or just one with:

    $ ./vedev stop ubuntu-14.1

When you finish, you may clean the packer box with:

    $ ./vedev clean box ubuntu-14.1

Or, you may delete the packer cache or the vagrant environment with the options 'clean cache' and 'clean vagrant'. Or clean it all with 'clean all'.

If you did not clean the box but cleaned the vagrant machine, you can initialize/re-create the vagrant machine  with:

    $ ./vedev init ubuntu-14.1

After build or initialize the machine, the environment is ready to be used for your development. Provision it using Docker, Puppet or a simple Shell Script and add more spec tests using ServerSpec. Just copy the directory of the vagrant machine inside the build directory, for example build/ubuntu-14.1*, to the development project directory.

## Tasks

- [X] **Testing**: Create a Rake file using ServerSpec to test.
- [ ] **Push to Atlas**: Once the Vagrant box is ready upload it to Altas (previously VagrantCloud). This is not possible yet. Waiting for Atlas to provide (free) packer push of vagrant-virtualbox boxes.
- [X] **Options**: Add more options to vedev such as update, init; and improve clean and build options.
- [X] **More Options**: Add more options to vedev such as up and down, to vagrant up && ssh and vagrant halt.
- [ ] **Official Boxes**: Allow to use an existing box on Atlas or in the cloud instead of creating your own box.
- [ ] **AWS**: Add Amazon Web Services as provider.
- [ ] **CoreOS**: Add CoreOS in the list of Linux distributions.
- [ ] **Sandbox**: Create dockerfiles provision and to create sandboxes for several kind of projects such as: NodeJS/AngularJS, Perl/Dancer, Ruby/Rails/Sinatra, etc...

## Why VeDeV?

VeDeV is an application to manage Packer and Vagrant, to build, initialize and start up virtual machines with the preferred Linux distribution. All this, to have a **non-lightweight** development environment to use Docker. VeDeV can be used instead of boot2docker but using the OS you want and using the advantages of vagrant. Advantages such as share the guest file system with the host. It is not lightweight, but this is an advantage, so we can use the guest OS for more than Docker stuff, maybe provision with Puppet and have a regular production environment.

VeDeV can be used in Mac OS X or Windows (CygWin), this allow a developer or a team to use the same development environment in any platform.

With VeDeV you can create several OS images to deploy, build and **test** your application. Then you can select which OS is better or modify your application to work fine in all of them.

I can re-build the environment when there is a new OS version or many packages to update. Don't waste time during the provisioning, updating the vagrant machine, just re-build the vagrant box with the new OS version and with all the packages updated.

## Thanks

The creation of the packer templates, scripts and http templates are based on several github projects. This is a project I used to learn packer and I thanks to all those developers that publish their work. 

In the same way, every body is free to use what I did to improve it or learn from it.

If you find an error, please, open a [Github Issue](https://github.com/johandry/vedev/issues).
