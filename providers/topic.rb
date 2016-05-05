include Kafka::Kafka_helper

use_inline_resources

def whyrun_supported?
  true
end

action :create do
  ensemble_dbag_key = new_resource.ensemble_data_bag_info.keys.first
  zk_connect = get_ensemble_string(get_active_host_hash(data_bag_item(ensemble_dbag_key, new_resource.ensemble_data_bag_info[ensemble_dbag_key])),new_resource.zookeeper_client_port)
  zookeeper_host =  zk_connect.split(',').sample

  execute "Create topic #{new_resource.name}" do
    cwd new_resource.install_path
    command "./bin/kafka-topics.sh --zookeeper #{zookeeper_host} --create --topic #{new_resource.name} --partitions #{new_resource.partitions} --replication-factor #{new_resource.replication_factor}"
    user new_resource.user
    not_if { topic_exists?(new_resource.install_path, zookeeper_host, new_resource.name) }
  end

end
def load_current_resource
  @current_resource = Chef::Resource::OmcKafkaTopic.new(@new_resource.name)
  @current_resource.user(@new_resource.user)
  @current_resource.install_path(@new_resource.install_path)
  @current_resource.ensemble_data_bag_info(@new_resource.ensemble_data_bag_info)
  @current_resource.zookeeper_client_port(@new_resource.zookeeper_client_port)
  @current_resource.replication_factor(@new_resource.replication_factor)
  @current_resource.partitions(@new_resource.partitions)
end
