#
# Cookbook Name:: maxdb
# Recipe:: default
#
#
#
node[:local_ip] ||= cf_local_ip
case node['platform']
  
when "ubuntu"
  arch = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"
  src = "https://sapmats-us.sap-ag.de/download/download.cgi?id=JFB1N77ZFZM7KZGOOA5S1PED4JIIIKTINNR3FTHFIV6341KG91&contype=application/x-gzip-compressed&password="
  folder = "maxdb-all-linux-64bit-x86_64-7_8_02_27"
  if arch == "i386"
    src = "https://sapmats-us.sap-ag.de/download/download.cgi?id=QHSPQ46BM366EYMP9UZ3FNO2T4PH2I6BRJFJLK8WOSEOPQLPYB&contype=application/x-gzip-compressed&password="
    folder = "maxdb-all-linux-32bit-i386-7_8_02_27"
    bash "Install dependencies" do
      user "root"
      cwd "/tmp"
      code <<-EOH
        wget "http://ftp.us.debian.org/debian/pool/main/g/gcc-3.3/libstdc++5_3.3.6-18_i386.deb"
        dpkg -i libstdc++5_3.3.6-18_i386.deb
        echo 'deb http://ubuntu.wikimedia.org/ubuntu lucid main' >/tmp/source_maxdb.list
        cp /tmp/source_maxdb.list /etc/apt/sources.list.d/
        rm /tmp/source_maxdb.list        
      EOH
    end
    %w{wx-common libpng3 libtiff4 makepasswd libgtk2.0-0 }.each do |p|
      package p do
         action [:install]
      end
    end
    bash "Create symbolic links" do
      user "root"
      cwd "/usr/lib"
      code <<-EOH
        ln -sf /lib/libpng12.so.0 /usr/lib/libpng.so.3
        ln -sf /usr/lib/libtiff.so.4 /usr/lib/libtiff.so3
      EOH
    end
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
  
 package "libshadow-ruby1.8" do
   action [:install]
 end
 
 user "sdb" do
   action :modify
   password "$1$F1NGDVEs$/yS3O5IY71zNtbuu1schL0"   
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
