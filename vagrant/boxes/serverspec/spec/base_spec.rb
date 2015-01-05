require 'spec_helper'

# Host must have internet access
describe host('www.google.com') do
  it { should be_reachable }
end

# Ruby version should be installed and higher than 2.X
describe command('ruby --version') do
  its(:stdout) { should match /ruby 2./ }
end

# Docker version should be installed and higher than 1.X
describe command('docker --version') do
  its(:stdout) { should match /Docker version 1./ }
end
