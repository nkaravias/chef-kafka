omc_kafka_node 'kafka' do
  home node[:omc_kafka][:home]
  source_url node[:omc_kafka][:source_url]
  kafka_version node[:omc_kafka][:kafka_version]
  scala_version node[:omc_kafka][:scala_version]
  install_path node[:omc_kafka][:install_path]
  log_path node[:omc_kafka][:log_path]
  action :install
end

omc_kafka_config 'kafka' do
  install_path node[:omc_kafka][:install_path]
  log_path node[:omc_kafka][:log_path]
  listen_port node[:omc_kafka][:listen_port]
  broker_data_bag_info node[:omc_kafka][:broker_data_bag_info]
  ensemble_data_bag_info node[:omc_zookeeper][:ensemble_data_bag_info]
  zookeeper_client_port node[:omc_zookeeper][:client_port]
  override_java_opts node[:omc_kafka][:override_java_opts]
  override_sysconfig node[:omc_kafka][:override_sysconfig]
  override_config node[:omc_kafka][:override_config]
  action :render
end

node[:omc_kafka][:topics].each do |topic|
  omc_kafka_topic topic['name'] do
    user node[:omc_kafka][:user]
    install_path node[:omc_kafka][:install_path]
    zookeeper_client_port node[:omc_zookeeper][:client_port]
    ensemble_data_bag_info node[:omc_zookeeper][:ensemble_data_bag_info]
    partitions topic['partitions']
    replication_factor topic['replication_factor']
  end
end
