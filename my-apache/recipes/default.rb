#
# Cookbook Name:: my-apache
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
# ~/learn-chef/chef-repo/cookbooks/my-apache/default.rb
#
# install apache
package "apache2" do
	action :install
end	
# start apache
# make sure dservice starts at boot
service "apache2" do
	action [:start,:enable]
end	
# write the new homepage
cookbook_file "/var/www/index.html" do
	source "index.html"
	mode 0644
end	


