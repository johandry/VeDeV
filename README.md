# vedev: Virtual Environment for Development

Create a Virtual Environment for Develoment using [Packer](http://www.packer.io/) to create the Vagrant Box, [Vagrant](https://www.vagrantup.com/) to manage the virtual machine, [VirtualBox](https://www.virtualbox.org/) as the virtualization software and [Docker](https://www.docker.com/)/[Puppet](http://puppetlabs.com/) to provision and configure the new environment.

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
