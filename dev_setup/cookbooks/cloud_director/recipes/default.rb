
template node[:cd][:config_file] do
  path File.join(node[:deployment][:config_path], node[:cd][:config_file])
  source "cloud_director.yml.erb"
  owner node[:deployment][:user]
  mode 0644
end
