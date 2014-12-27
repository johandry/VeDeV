#!/usr/bin/env ruby

################################################################################
# Title: build.rb
# Description: Wrapper script to build a vagrant box using packer and create the Vagrant environment.
# Author: Johandry Amador (johandry@gmail.com)
# Date: 12/13/2014
# Usage help: build.rb
################################################################################

require 'thor'

class Vedev < Thor

  class_option :verbose, :type => :boolean, :aliases => "-v", :default => false

  desc "build DISTRO", "Build a vagrant box using packer and a vagrant environment using a DISTRO"
  method_option :only_box, :type => :boolean, :alias => "-b", :desc => "Build only the box with packer. Do not add it to vagrant."
  def build(distro)
    if distro.upcase == "all".upcase
      distros = get_distros('')
      distros.each do |distro|
        info "Building distro #{distro}"
        paker_build distro
        vagrant_build distro
      end
    else
      distro = check_distro(distro)
      if distro then
        paker_build distro
        vagrant_build distro
      end
    end
  end

  desc "clean OBJECT", "Clean (moving to a Trash directory) everything or an OBJECT. Available objects are: all, cache, boxes, vagrant"
  def clean(object)

    date = Time.now.strftime("%Y%m%d")
    FileUtils.mkdir_p Dir.pwd + "/Trash/#{date}"

    if object.upcase == "box".upcase
      clean_box date
    elsif object.upcase == "cache".upcase
      clean_cache date
    elsif object.upcase == "vagrant".upcase
      clean_vagrant date
    elsif object.upcase == "all".upcase
      clean_box date
      clean_cache date
      clean_vagrant date
    end    
  end

  desc "list", "List all the available distros to build"
  def list
    info "The available distros are:"
    Dir[Dir.pwd + '/packer/templates/*.json'].sort.each do |distro|
      say "\t\t* ", :green
      say "#{distro.gsub(%r|.*/packer/templates/(.*).json|,'\1')}"
    end
  end

private
  def error(message)
    say_status "[ERROR]", message, :red
  end

  def warning(message)
    say_status "[WARNING]", message, :yellow
  end

  def info(message)
    say_status "[INFO]", message, :green
  end

  def log(message)
    say_status "[DEBUG]", message, :blue if options[:verbose]
  end

  def get_distros(name)
    # If name is '' will return all the distros
    Dir[Dir.pwd + "/packer/templates/#{name}*.json"].sort.map { |file_name|
      file_name.gsub(%r|.*/packer/templates/(.*).json|,'\1')
    }
  end

  def check_distro(name)
    distros = get_distros(name)

    if distros.length > 1 then
      warning "There are #{distros.length} distros starting with name '#{name}'."
      warning "Select the right one from:"
      distros.each { |distro|  
        say "\t\t* ", :yellow
        say distro 
      }
      return nil
    end
    if distros.length < 1 then
      error "Sorry, there is no template for a distro starting with '#{name}'. "
      list
      return nil
    end
    distros[0]
  end

  def clean_box(date)
    if Dir.glob(Dir.pwd + '/vagrant/boxes/*.box').empty?
      info "No boxes to clean"
    else
      box_count = Dir.glob(Dir.pwd + '/vagrant/boxes/*.box').length
      warning "Moving #{box_count} boxes to Trash/#{date}/boxes"
      FileUtils.mv Dir.pwd + '/vagrant/boxes/', Dir.pwd + "/Trash/#{date}", :force => true
    end
  end

  def clean_cache(date)
    if ! File.directory?(Dir.pwd + '/packer_cache')
      info "No packer cache to clean"
    else
      warning "Moving Packer Cache to Trash/#{date}"
      FileUtils.mv Dir.pwd + '/packer_cache', Dir.pwd + "/Trash/#{date}", :force => true
    end
  end

  def clean_vagrant(date)
    total = `vagrant box list | grep -v 'no installed boxes' | wc -l | sed 's/ //g'`
    count = 0

    if File.directory?(Dir.pwd + '/vagrant')
      vagrant_boxes_dir = Dir[File.join(Dir.pwd + '/vagrant/', '*')].select { |file| File.directory?(file) && file !~ /\/vagrant\/boxes$/ }
      count = vagrant_boxes_dir.length
      vagrant_boxes_dir.each do |box|
        box_name = box[/.*\/(.*)/,1]
        warning "Destroying vagrant box 'vagrant-#{box_name}'"
        system "cd #{box}; vagrant destroy -f"
        warning "Removing vagrant box 'vagrant-#{box_name}'"
        system "cd #{box}; vagrant box remove 'vagrant-#{box_name}'"
        warning "Moving vagrant box 'vagrant-#{box_name}' to Trash/#{date}"
        FileUtils.mv box, Dir.pwd + "/Trash/#{date}", :force => true
      end
    end

    info "Removed #{count}/#{total} vagrant boxes"
  end

  def paker_build(distro)
    info "Building vagrant box for distro #{distro}"
    system "packer build " + Dir.pwd + "/packer/templates/#{distro}.json"
    info "Vagrant box for distro #{distro} is done"
  end

  def vagrant_build(distro)
    info "Creating vagrant environment for distro #{distro}"
    system "vagrant box add 'vagrant-#{distro}' '" + Dir.pwd + "/vagrant/boxes/#{distro}.box'"
    FileUtils.mkdir_p Dir.pwd + "/vagrant/#{distro}"
    system "cd " + Dir.pwd + "/vagrant/#{distro}; vagrant init 'vagrant-#{distro}'"
    info "Vagrant environment for distro #{distro} is done. Now you can start it with 'vagrant up'"  
  end
end

Vedev.start(ARGV)