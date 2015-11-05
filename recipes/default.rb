#
# Cookbook Name:: omc_kafka
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
=begin
omc_kafka_node 'kafka' do
  #user 'kafka'
  #group 'kafka'
  #shell '/bin/bash'
  home '/opt/kafka_home'
  source_url 'http://www.mirrorservice.org/sites/ftp.apache.org/kafka/0.8.2.0/kafka_2.10-0.8.2.0.tgz'
  kafka_version '0.8.2.0'
  scala_version '2.10'
  install_path '/opt/kafka'
  log_path '/var/log/kafka'
  action :install
end

omc_kafka_config 'kafka' do
  #user 'kafka'
  #group 'kafka'
  install_path '/opt/kafka'
  log_path '/var/log/kafka'
  listen_port 9092
  broker_data_bag_info 'slapchop' => 'kafka_localdev'
  ensemble_data_bag_info 'slapchop' => 'zookeeper_localdev'
  zookeeper_client_port 2181
  #java_opts 
  override_java_opts {}
  #default_sysconfig 
  override_sysconfig {}
  #default_config 
  override_config  {}
  action :render
end
=end
