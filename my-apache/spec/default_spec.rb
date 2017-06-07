require 'chefspec'

describe 'my-apache::default' do
let(:chef_run) {
   ChefSpec::Runner.new.converge(described_recipe)
}  

it 'creates a file' do
expect(chef_run).to create_file('/var/www/index.html')  
end
end
