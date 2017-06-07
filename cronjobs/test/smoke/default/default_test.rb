# # encoding: utf-8

# Inspec test for recipe cronjobs::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

describe command( 'date' ) do
	it { should exist }
	its('exit_status') { should eq 0 }
    its( 'stdout' ) { should match /Jun/ }
  end
