#
# Cookbook:: httpd
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
include_recipe 'httpd::install'

file '/var/www/html/index.html' do
	content '<h1>Welcome Home!</h1>'
end


service 'httpd' do
	action [:enable,:start]
end	