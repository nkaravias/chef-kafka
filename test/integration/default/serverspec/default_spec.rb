# -*- coding: utf-8 -*-

require 'spec_helper'

kfk_usr = 'kafka'
kfk_grp = 'kafka'

describe user(kfk_usr) do
  it { should belong_to_group kfk_grp }
  it { should have_home_directory '/opt/kafka_home' }
end

install_path = '/opt/kafka'
kfk_dirs = {'config_path' => File.join(install_path,'config'), 'log_path' => '/var/log/kafka'}

kfk_files = {'server.properties' => File.join(install_path,'config','server.properties'), 'initd' => '/etc/init.d/kafka', 'sysconfig' => '/etc/sysconfig/kafka'}

kfk_dirs.each do |k,v|
  describe file(v) do
    it { should be_directory }
    it { should be_owned_by kfk_usr }
    it { should be_grouped_into kfk_grp }
  end
end

kfk_files.each do |k,v|
  describe file(v) do
    it { should be_file }
    it { should be_owned_by kfk_usr }
    it { should be_grouped_into kfk_grp }
  end
end

describe service('kafka') do
  it { should be_enabled }
  it { should be_running }
end

[ 9092 ].each do |port|
  describe port(port) do
    it { should be_listening }
  end
end

