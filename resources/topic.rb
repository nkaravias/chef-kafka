actions :create, :delete
default_action :create

attribute :user, :kind_of => String, default: 'kafka'
attribute :install_path, :kind_of => String, default: '/opt/kafka'
attribute :zookeeper_client_port, :kind_of => Integer, default: 2181
attribute :replication_factor, :kind_of => Integer, default: 1
attribute :partitions, :kind_of => Integer, default: 1
attribute(:ensemble_data_bag_info, kind_of: Hash,   required: true)
