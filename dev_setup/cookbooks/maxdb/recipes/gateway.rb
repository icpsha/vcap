#
# Cookbook Name:: gateway
# Recipe:: default
#


cloudfoundry_service "maxdb" do
  components ["maxdb_gateway"]
end
