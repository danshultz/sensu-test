#
# Cookbook Name:: sensu-test::server
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

{
  :server_root_password => 'rootpass',
  :server_debian_password => 'debpass',
  :server_repl_password => 'replpass',
  :use_ssl => false
}.each { |k,v| node.normal[:sensu][k] = v }

# include after setting node values
include_recipe('sensu')

# Hack to get the eth1 ip address as this is usually the public ip
address = node.network["interfaces"]["eth1"]["addresses"].detect do |ip, params|
  params['family'] == ('inet')
end
ip_address = address && address[0] || node.ipaddress
Chef::Log.info("#{node.name} has IP address #{ip_address}")

# may want set the nodename specifically
sensu_client(node.name) {
  address(ip_address) # this is only for the server
  subscriptions(node.roles + ["all"]) # this may make sense
  additional(:cluster => "dan-test-one")
}

# Include all sensu service recipes
%w(
  rabbitmq
  redis
  server_service
  client_service
  api_service
  dashboard_service
).each { |recipe| include_recipe("sensu::#{recipe}") }

