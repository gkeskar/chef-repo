#
# Cookbook:: django
# Recipe:: install_pip
#
# Copyright:: 2017, The Authors, All Rights Reserved.
package 'python3-pip'

#execute 'pip3 install django'

pip 'django' do 
	action :install
end