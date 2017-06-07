resource_name :pip

# TODO : how to specify pip python
action :install do 
	execute 'pip3 install django'
end