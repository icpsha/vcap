#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2011, VMware
#
#

case node['platform']
  
when "ubuntu"
  bash "Install maxdb" do
    user "root"
    cwd "/tmp"
    code <<-EOH
      mkdir maxdb && cd maxdb
      wget -O linux_maxdb.tgz --no-check-certificate "https://sapmats-us.sap-ag.de/download/download.cgi?id=JFB1N77ZFZM7KZGOOA5S1PED4JIIIKTINNR3FTHFIV6341KG91&contype=application/x-gzip-compressed&password="
      tar -xvzf linux_maxdb.tgz
      cd maxdb-all-linux-64bit-x86_64-7_8_02_27
      ./SDBINST     
    EOH
    not_if do
      ::File.exists?(File.join("", "opt", "sdb", "globalprograms"))
    end
  end
  bash "Setup maxdb" do  # By default globallistener doesn't start in linux machines
    user "root"
    cwd "#{File.join('', 'opt', 'sdb', 'globalprograms','bin')}"
    code <<-EOH
      ./sdbgloballistener start
    EOH
    only_if do
      ::File.exists?(File.join("", "opt", "sdb", "globalprograms"))
    end
  end
else
  Chef::Log.error("Installation of maxdb not supported on this platform.")
end
