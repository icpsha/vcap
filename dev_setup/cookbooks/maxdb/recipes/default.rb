#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2011, VMware
#
#

case node['platform']
  
when "ubuntu"
  arch = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"
  src = "https://sapmats-us.sap-ag.de/download/download.cgi?id=JFB1N77ZFZM7KZGOOA5S1PED4JIIIKTINNR3FTHFIV6341KG91&contype=application/x-gzip-compressed&password="
  folder = "maxdb-all-linux-64bit-x86_64-7_8_02_27"
  if arch == "i386"
    src = "https://sapmats-us.sap-ag.de/download/download.cgi?id=QHSPQ46BM366EYMP9UZ3FNO2T4PH2I6BRJFJLK8WOSEOPQLPYB&contype=application/x-gzip-compressed&password="
    folder = "maxdb-all-linux-32bit-i386-7_8_02_27"
  end

  bash "Install maxdb" do
    user "root"
    cwd "/tmp"
    code <<-EOH
      mkdir maxdb && cd maxdb
      wget -O linux_maxdb.tgz --no-check-certificate "#{src}"
      tar -xvzf linux_maxdb.tgz
      cd #{folder}
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
