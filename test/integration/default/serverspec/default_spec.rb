# -*- coding: utf-8 -*-

require 'spec_helper'

i = 0
$node.each do |k,v|
  puts "#{i}:#{k}:#{v}"
  i+=1
end
$node['omc_kafka'].tap do |kfk|
  kfk_usr = 'kafka'
  kfk_grp = 'kafka'
  kfk_dirs = [ kfk['install_path'], kfk['log_path'] ]
  kfk_files = [ File.join(kfk['install_path'],'config','server.properties'), '/etc/init.d/kafka', '/etc/sysconfig/kafka' ]

  describe user(kfk_usr) do
    it { should belong_to_group kfk_grp }
    it { should have_home_directory kfk['home'] }
  end

  kfk_dirs.each do |dir| #|k,v|
    describe file(dir) do
      it { should be_directory }
      it { should be_owned_by kfk_usr }
      it { should be_grouped_into kfk_grp }
    end
  end

  kfk_files.each do |kfk_file| #|k,v|
    describe file(kfk_file) do
      it { should be_file }
      it { should be_owned_by kfk_usr }
      it { should be_grouped_into kfk_grp }
    end
  end

  describe service('kafka') do
    it { should be_enabled }
    it { should be_running }
  end

  [ kfk['listen_port'] ].each do |port|
    describe port(port) do
      it { should be_listening }
    end
  end

end
