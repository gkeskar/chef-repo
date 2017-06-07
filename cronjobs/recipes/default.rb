#
# Cookbook:: cronjobs
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
cron 'date' do
  minute '0'
  hour  '20'
  command 'date'
end
file "/root/.monitor.cnf" do
	owner "root"
	group "root"
	mode 0600
	content <<-EOF
	[mysql]
	user=monitor
    EOF
end 