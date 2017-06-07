#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# execute sudo yum install java-1.7.0-openjdk-devel

package node['tomcat']['java']
  
group 'tomcat' do
  not_if 'grep tomcat /etc/passwd', :group => 'tomcat'
end  

user 'tomcat' do
  group 'tomcat'
  manage_home false
  home "#{node['tomcat']['dir']}"
  #home node.['tomcat']['dir']
  shell '/bin/nologin'
  not_if 'grep tomcat /etc/passwd', :user => 'tomcat'
end

# http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.0.44/bin/apache-tomcat-8.0.44.tar.gz 

remote_file 'apache-tomcat-8.0.44.tar.gz' do
  source 'http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.0.44/bin/apache-tomcat-8.0.44.tar.gz'
end
# if remote file change notify down below to extract 

directory node['tomcat']['dir'] do
  #owner 'tomcat'
  group 'tomcat'
  mode '0070'
  action :create
  only_if do ! Dir.exist?("#{node['tomcat']['dir']}") end
end

#TODO not desired state

execute "tar xvf apache-tomcat-8*tar.gz -C #{node['tomcat']['dir']} --strip-components=1" do
  only_if do ! Dir.exist?("#{node['tomcat']['dir']}/conf") end
end 


directory "#{node['tomcat']['dir']}/conf" do
  mode '0070'
  group 'tomcat'
  recursive true
  action :create
  notifies :run, 'execute[conf-recurs-grp-tomcat]', :immediately
  notifies :run, 'execute[conf-recurs-grp-read]', :immediately
  notifies :run, 'execute[dirs-recurs-chown-tomcat]', :immediately
  notifies :run, 'execute[reload-tomcat-config]', :delayed
end

#TODO not desired state  => if this block is taken out does not work when you create everything 
execute 'conf-recurs-grp-tomcat' do # recursively make group tomcat
  command "chgrp -R tomcat #{node['tomcat']['dir']}/conf" 
  action :nothing#do
  #only_if do ! Dir.exist?('/opt/tomcat/conf') end
#end
end 

execute 'conf-recurs-grp-read' do # read permission to group 
  command "chmod g+r #{node['tomcat']['dir']}/conf/*"
  action :nothing
end

#execute 'dir-recurs-owner' do # set owner to tomcat for other dir
  #%w[webapps work temp logs].each do |path|
  #command "chown -R tomcat /opt/tomcat/#{path}"
  #only_if do ! Dir.exist?("#{node['tomcat']['dir']}/#{path}") end
  #end
#end

execute "dirs-recurs-chown-tomcat" do
    #%w[webapps work temp logs].each do |path|
    command "chown -R tomcat #{node['tomcat']['dir']}/webapps #{node['tomcat']['dir']}/work #{node['tomcat']['dir']}/temp #{node['tomcat']['dir']}/logs"
    action :nothing     
end

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
  notifies :run, 'execute[reload-tomcat-config]', :immediately
  notifies :restart, 'service[tomcat]', :immediately
  only_if do ! File.exist?('/etc/systemd/system/tomcat.service') end

end

#TODO not desired state
execute 'reload-tomcat-config'do
  command 'systemctl daemon-reload'
  action  :nothing
end

service 'tomcat' do
  action [:start, :enable]
end
  