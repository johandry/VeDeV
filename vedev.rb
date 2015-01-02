#!/usr/bin/env ruby

################################################################################
# Title: build.rb
# Description: Wrapper script to build a vagrant box using packer and create the Vagrant environment.
# Author: Johandry Amador (johandry@gmail.com)
# Creation Date: 12/13/2014
# Usage help: build.rb
################################################################################

require 'thor'
require 'json'
require 'pathname'
require 'net/http'

module VeDeV
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

    if distros.length > 1
      warning "There are #{distros.length} distros starting with name '#{name}'."
      warning "Select the right one from:"
      distros.each { |distro|  
        say "\t\t* ", :yellow
        say distro 
      }
      return nil
    end
    if distros.length < 1
      error "Sorry, there is no template for a distro starting with '#{name}'. "
      info "The available distros are:"
      Dir[Dir.pwd + '/packer/templates/*.json'].sort.each do |distro|
        say "\t\t* ", :green
        say "#{distro.gsub(%r|.*/packer/templates/(.*).json|,'\1')}"
      end
      return nil
    end
    distros[0]
  end

  class Clean < Thor
    include VeDeV

    desc "all [DISTRO]", "Clean (moving to a Trash directory) everything (boxes and vagrant environment) of a DISTRO or from ALL the distros. It will delete the entire packer cache for any distro. Distro could be 'all' or any of the distros listed with option 'list'."
    def all(distro='all')

      if distro.upcase != "all".upcase
        distro = check_distro distro
        return nil if distro == nil
      end

      date = Time.now.strftime("%Y%m%d")
      FileUtils.mkdir_p Dir.pwd + "/Trash/#{date}"

      box distro
      cache
      vagrant distro 
    end

    desc "box [DISTRO]", "Clean (moving to a Trash directory) the builded box of a DISTRO or from ALL the distros. Distro could be 'all' or any of the distros listed with option 'list'."
    def box(distro='all')
      if distro.upcase != "all".upcase
        distro = check_distro distro
        return nil if distro == nil
      end

      date = Time.now.strftime("%Y%m%d")
      FileUtils.mkdir_p Dir.pwd + "/Trash/#{date}"

      if distro.upcase != "all".upcase
        if Dir.glob(Dir.pwd + "/vagrant/boxes/#{distro}.box").empty?
          info "No box for #{distro} to clean"
        else 
          warning "Moving 1 box to Trash/#{date}/boxes"
          FileUtils.mkdir_p Dir.pwd + "/Trash/#{date}/boxes"
          FileUtils.mv Dir.pwd + "/vagrant/boxes/#{distro}.box", Dir.pwd + "/Trash/#{date}/boxes", :force => true
        end
      else
        if Dir.glob(Dir.pwd + '/vagrant/boxes/*.box').empty?
          info "No boxes to clean"
        else
          box_count = Dir.glob(Dir.pwd + '/vagrant/boxes/*.box').length
          warning "Moving #{box_count} boxes to Trash/#{date}/boxes"
          FileUtils.mkdir_p Dir.pwd + "/Trash/#{date}/boxes"
          FileUtils.mv Dir.glob(Dir.pwd + '/vagrant/boxes/*.box'), Dir.pwd + "/Trash/#{date}/boxes", :force => true
        end
      end
    end

    desc "cache", "Clean (moving to a Trash directory) the entire packer cache."
    def cache()
      date = Time.now.strftime("%Y%m%d")
      FileUtils.mkdir_p Dir.pwd + "/Trash/#{date}"

      if ! File.directory?(Dir.pwd + '/packer_cache')
        info "No packer cache to clean"
      else
        warning "Moving Packer Cache to Trash/#{date}"
        FileUtils.mv Dir.pwd + '/packer_cache', Dir.pwd + "/Trash/#{date}", :force => true
      end
    end

    desc "vagrant [DISTRO]", "Clean (moving to a Trash directory) the vagrant environment of a DISTRO or from ALL the distros. Distro could be 'all' or any of the distros listed with option 'list'."
    def vagrant(distro='all')
      if distro.upcase != "all".upcase
        distro = check_distro distro
        return nil if distro == nil
      end

      date = Time.now.strftime("%Y%m%d")
      FileUtils.mkdir_p Dir.pwd + "/Trash/#{date}"

      total = `vagrant box list | grep -v 'no installed boxes' | wc -l | sed 's/ //g'`.chop
      count = 0

      if File.directory?(Dir.pwd + '/vagrant')
        if distro.upcase != "all".upcase
          if Dir.glob(Dir.pwd + "/vagrant/#{distro}").empty?
            info "No vagrant box for #{distro}"
          else
            count = 1
            status = clean_vagrant_box(Dir.pwd + "/vagrant/#{distro}", date)
            cound = 0 if not status
          end
        else
          vagrant_boxes_dir = Dir[File.join(Dir.pwd + '/vagrant/', '*')].select { |file| File.directory?(file) && file !~ /\/vagrant\/boxes$/ }
          count = vagrant_boxes_dir.length
          vagrant_boxes_dir.each do |box|
            status = clean_vagrant_box(box, date)
            count -= 1 if not status
          end
        end
      end

      info "Removed #{count}/#{total} vagrant boxes"
    end

    private
      def clean_vagrant_box(box, date)
        status = nil
        box_name = box[/.*\/(.*)/,1]
        if `vagrant box list | grep 'vagrant-#{box_name}' | wc -l | sed 's/ //g'`.chop.to_i != 0
          Dir.chdir box do
            warning "Destroying vagrant box 'vagrant-#{box_name}'"
            status = system  "vagrant destroy -f"
            if status
              warning "Removing vagrant box 'vagrant-#{box_name}'"
              status = system  "vagrant box remove 'vagrant-#{box_name}'"
              error "Vagrant box could not be removed" if not status 
            else
              error "Vagrant box 'vagrant-#{box_name}' could not be destroyed"
            end
          end
        else
          error "There is no 'vagrant-#{box_name}' box to destroy or remove"
        end
        if File.directory?(Dir.pwd + "/Trash/#{date}/#{box_name}")
          FileUtils.remove_dir(Dir.pwd + "/Trash/#{date}/#{box_name}")
          warning "Removed a previous version of vagrant directory #{box_name} in Trash/#{date}"
        end
        warning "Moving vagrant directory '#{box}' to Trash/#{date}"
        FileUtils.mv box, Dir.pwd + "/Trash/#{date}", :force => true
        status
      end
  end

  class List < Thor
    include VeDeV

    desc "build", "List all the available distros to build"
    def build
      info "The available distros are:"
      Dir[Dir.pwd + '/packer/templates/*.json'].sort.each do |distro|
        say "\t\t* ", :green
        say "#{distro.gsub(%r|.*/packer/templates/(.*).json|,'\1')}"
      end
    end

    desc "init", "List all the available distros to initialize"
    def init
      info "The available boxes are:"
      Dir[Dir.pwd + '/vagrant/boxes/*.box'].sort.each do |distro|
        say "\t\t* ", :green
        say "#{distro.gsub(%r|.*/vagrant/boxes/(.*).box|,'\1')}"
      end
    end
  end

  class Vedev < Thor
    include VeDeV

    class_option :verbose, :type => :boolean, :aliases => "-v", :default => false

    desc "build [DISTRO]", "Build a vagrant box using packer and initialize a vagrant environment using a DISTRO"
    method_option :only_box, :type => :boolean, :alias => "-b", :desc => "Build only the box with packer. Do not add it to vagrant."
    def build(distro='all')
      if distro.upcase == "all".upcase
        distros = get_distros('')
        distros.each do |distro|
          info "Building distro #{distro}"
          build_status = paker_build distro
          # if build_status
          #   info "Pushing distro box to Atlas"
          #   packer_push distro
          # end
          if ! options[:only_box] && build_status
            info "Initializing distro #{distro}"
            vagrant_init distro 
          end
        end
      else
        distro = check_distro(distro)
        if distro 
          build_status = paker_build distro
          # if build_status
          #   info "Pushing distro box to Atlas"
          #   packer_push distro
          # end
          if ! options[:only_box] && build_status
            info "Initializing distro #{distro}"
            vagrant_init distro 
          end
        end
      end
    end

    desc "init [DISTRO]", "Initialize a vagrant environment using a DISTRO"
    def init(distro='all')
      if distro.upcase == "all".upcase
        distros = get_distros('')
        distros.each do |distro|
          info "Initializing distro #{distro}"
          vagrant_init distro
        end
      else
        distro = check_distro(distro)
        if distro
          info "Initializing distro #{distro}"
          vagrant_init distro
        end
      end
    end

    desc "update [DISTRO]", "Clean up all to build and init the DISTRO or all the distros."
    def update(distro='all')
      clean = Clean.new
      if clean.all(distro)
        build(distro) 
      end
    end

    desc "validate [DISTRO]", "Validate the packer template for a DISTRO or all of them."
    def validate(distro='all')
      status = true
      if distro.upcase == "all".upcase
        distros = get_distros('')
        distros.each do |distro|
          status = packer_validate distro
          status = packer_check_iso distro
        end
      else
        distro = check_distro(distro)
        if distro
          status = packer_validate distro
          pstatus = acker_check_iso distro
        end
      end
      if status
        info "All test were successfull"
      else
        error "Some test failed"
      end
    end

    desc "list SUBCOMMAND ...ARGS", "List available distros to build or boxes to initialize"
    subcommand "list", List

    desc "clean SUBCOMMAND ...ARGS", "Clean (moving to a Trash directory) different artifacts for one or every distro."
    subcommand "clean", Clean

    private
      def paker_build(distro)
        status = nil
        if ! Dir.glob(Dir.pwd + "/vagrant/boxes/#{distro}.box").empty?
          error "There is a vagrant box for #{distro}. Clean it before build it."
        else
          info "Building vagrant box for distro #{distro}"
          status = system "packer build -var-file=" + Dir.pwd + "/packer/vars/global_variables.json " + Dir.pwd + "/packer/templates/#{distro}.json"
          if status
            info "Vagrant box for distro #{distro} is done"
          else
            error "Vagrant box for #{distro} was not done"
          end
        end
        status
      end

      def packer_validate(distro)
        info "Validating distro #{distro}"
        if system "packer validate -var-file=" + Dir.pwd + "/packer/vars/global_variables.json " + Dir.pwd + "/packer/templates/#{distro}.json"
          info "Template for distro #{distro} is valid"
        else
          error "Template for #{distro} is not valid"
        end
      end

      def packer_check_iso(distro)
        info "Checking if the ISO URL exists"
        template = Pathname.new(Dir.pwd + "/packer/templates/#{distro}.json")
        json = JSON.parse(template.read)
        iso_url = json['variables']['iso_url']
        url_exist iso_url
      end

      def url_exist(url_string)
        url = URI.parse(url_string)
        req = Net::HTTP.new(url.host, url.port)
        req.use_ssl = (url.scheme == 'https')
        path = url.path.empty? ? '/' : url.path
        res = req.request_head(path)
        if not (res.is_a?(Net::HTTPSuccess) || res.is_a?(Net::HTTPRedirection))
          error "URL #{url_string} does not exists"
          return
        end
        if res['content-type'].include? 'text/html'
          error "Content of URL #{url_string} is not an ISO file"
        else
          info "URL #{url_string} exists and it is a ISO"
        end
      rescue Errno::ENOENT
        error "Cannot find the server for #{url_string}"
        false # false if can't find the server
      end

      def vagrant_init(distro)
        status = nil
        if Dir.glob(Dir.pwd + "/vagrant/boxes/#{distro}.box").empty?
          error "There is no vagrant box for #{distro}. Build it before initialize it."
        elsif ! Dir.glob(Dir.pwd + "/vagrant/#{distro}").empty?
          error "There may be a vagrant environment for #{distro}. Clean it before initialize it."
        else
          info "Creating vagrant environment for distro #{distro}"
          status = system "vagrant box add 'vagrant-#{distro}' '" + Dir.pwd + "/vagrant/boxes/#{distro}.box'"
          if status
            FileUtils.mkdir_p Dir.pwd + "/vagrant/#{distro}"
            Dir.chdir Dir.pwd + "/vagrant/#{distro}" do
              status = system "vagrant init 'vagrant-#{distro}'"
            end
            if status 
              info "Vagrant environment for distro #{distro} is done. Now you can start it with 'vagrant up'" 
            else 
              error "Vagrant environment for distro #{distro} could not be initialized."
            end
          else
            error "Vagrant box for distro #{distro} could not be added"
          end
        end 
        status
      end
  end

  Vedev.start(ARGV)
end