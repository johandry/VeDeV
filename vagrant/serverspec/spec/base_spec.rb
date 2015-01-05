require 'spec_helper'

# Host must have internet access
describe host('www.google.com') do
  it { should be_reachable }
end

describe yumrepo('epel'), if: os[:family] == 'redhat' do
  it { should exist }
end

# describe selinux, if: os[:family] == 'redhat' do
#   it { should be_enforcing }
# end

# Openssh package and ssh service should exists and running
describe package('openssh-server') do
  it { should be_installed }
end

def sshd
  case os[:family]
  when /(debian|ubuntu)/
    'ssh'
  else
    'sshd'
  end
end

describe service(sshd) do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/ssh/sshd_config') do
  its(:content) { should match /UseDNS no/ }
end

# Checking time is UTC
describe command('date +%Z') do
  its(:stdout) { should match /UTC/ }
end

# Checking vagrant specs
describe user('vagrant') do
  it { should exist }
  it { should belong_to_group 'vagrant' }
  it { should have_home_directory '/home/vagrant' }
  # it { should have_authorized_key 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==' }
end

describe file('/home/vagrant/.ssh') do
  it { should be_directory }
  it { should be_owned_by 'vagrant' }
  it { should be_grouped_into 'vagrant' }
  it { should be_mode 700 }
end

describe file('/home/vagrant/.ssh/authorized_keys') do
  it { should be_file }
  it { should be_owned_by 'vagrant' }
  it { should be_grouped_into 'vagrant' }
  it { should be_mode 600 }
end

describe file('/etc/vagrant_box_build_time') do
  it { should be_file }
end

# Ruby should be installed and with version 1.9 or higher
describe command('ruby --version') do
  its(:stdout) { should match /ruby (1\.9|2\.)/ }
  its(:exit_status) { should eq 0 }
end

# Docker should be installed and with version higher than 1.X
describe command('docker --version') do
  its(:stdout) { should match /Docker version 1./ }
  its(:exit_status) { should eq 0 }
end
