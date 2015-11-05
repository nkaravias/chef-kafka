include_recipe 'java'

omc_zookeeper_node 'zookeeper' do
  home node[:omc_zookeeper][:home]
  source_url node[:omc_zookeeper][:source_url]
  version node[:omc_zookeeper][:version]
  install_path node[:omc_zookeeper][:install_path]
  data_path node[:omc_zookeeper][:data_path]
  log_path node[:omc_zookeeper][:log_path]
  config_path node[:omc_zookeeper][:config_path]
  action :install
end

omc_zookeeper_config ::File.join('/opt/zookeeper/conf', 'zoo.cfg') do
  ensemble_data_bag_info node[:omc_zookeeper][:ensemble_data_bag_info]
  client_port node[:omc_zookeeper][:client_port]
  quorum_port node[:omc_zookeeper][:quorum_port]
  leader_port node[:omc_zookeeper][:leader_port]
  instance node['fqdn'].downcase
  service_name node[:omc_zookeeper][:servicename]
  install_path node[:omc_zookeeper][:install_path]
  data_path node[:omc_zookeeper][:data_path]
  log_path node[:omc_zookeeper][:log_path]
  config_path node[:omc_zookeeper][:config_path]
  override_config node[:omc_zookeeper][:override_config]
  action :render
end
