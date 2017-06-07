#
# Cookbook:: cronjobs
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'cronjobs::default' do
  context 'When all attributes are default, on an Ubuntu 14.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates a cron with an explicit action' do
      expect(chef_run).to create_cron('date')
    end

    it 'creates a cron with attributes' do
      expect(chef_run).to create_cron('date').with(minute: '0', hour: '20')
      expect(chef_run).to_not create_cron('date').with(minute: '10', hour: '30')
    end

    it "creates /root/.monitor.cnf" do
      expect(chef_run).to create_file("/root/.monitor.cnf").with(
        owner: "root",
        group: "root",
        mode: 0600,
        content: "mysql\nuser=monitor\n"
      )
    end

  end
end
