#
# Cookbook Name:: cloudfoundry
# Recipe:: default
#
# Copyright 2011, VMWare
#
#

# Gem packages have transient failures, so ignore failures
#gem_package "vmc" do
# ignore_failure true
#  gem_binary File.join(node[:ruby][:path], "bin", "gem")
#end
gem_package "vmc_virgo" do
  gem_binary File.join(node[:ruby][:path], "bin", "gem")
  version "0.0.1"
  options "--pre"      
end