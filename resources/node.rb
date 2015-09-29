actions :install
default_action :install

attribute :user, :kind_of => String, default: 'kafka'
attribute :group, :kind_of => String, default: 'kafka'
attribute :shell, kind_of: String, default: '/bin/bash'
attribute :home, :kind_of => String, default: '/opt/kafka_home'

attribute :source_url, :kind_of => String, default: 'http://www.mirrorservice.org/sites/ftp.apache.org/kafka/0.8.2.0/kafka_2.10-0.8.2.0.tgz'
attribute :kafka_version, kind_of: String, default: '0.8.2.0'
attribute :scala_version, kind_of: String, default: '2.10'

attribute :install_path, :kind_of => String, default: '/opt/kafka'
attribute :log_path, :kind_of => String, default: '/var/log/kafka'
