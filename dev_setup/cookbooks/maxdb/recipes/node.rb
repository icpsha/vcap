#
# Cookbook Name:: node
# Recipe:: default
#


cloudfoundry_service "maxdb" do
  components ["maxdb_node"]
end
