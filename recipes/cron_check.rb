#
# Cookbook Name:: sensu-test::cron_check
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

sensu_check("cron_process") {
  command("/etc/sensu/plugins/check-procs.rb -p crond -C 1")
  handlers(["default"])
  subscribers(["webservers"])
  interval 30
  additional(:notification => "Cron is not running", :occurrences => 5)
}
