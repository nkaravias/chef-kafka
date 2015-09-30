actions :render
default_action :render

attribute :user, :kind_of => String, default: 'kafka'
attribute :group, :kind_of => String, default: 'kafka'

attribute :install_path, :kind_of => String, default: '/opt/kafka'
attribute :log_path, :kind_of => String, default: '/var/log/kafka'

attribute :listen_port, :kind_of => Integer, default: 9092
attribute :zookeeper_client_port, :kind_of => String, default: '2181'
attribute(:ensemble_data_bag_info, kind_of: Hash,   required: true)
attribute(:broker_data_bag_info, kind_of: Hash,   required: true)
# Default JVM options
attribute(:java_opts, kind_of: Hash, default: {
'-Xmx' => '512m',
'-Xms' => '256m',
'-Xss' => '256k',
'-server' => '',
'-Djava.awt.headless='=>true,
'-XX:+CMSClassUnloadingEnabled' => '',
'-XX:+CMSScavengeBeforeRemark' => '',
'-XX:+DisableExplicitGC' => '',
'-XX:+UseG1GC' => '',
'-XX:MaxGCPauseMillis=' => '20',
'-XX:InitiatingHeapOccupancyPercent=' => '35'
})
# Override
attribute(:override_java_opts, kind_of: Hash, default: {})

attribute(:default_sysconfig, kind_of: Hash, default: {
'KAFKA_HOME' => '',
'KAFKA_JVM_PERFORMANCE_OPTS' => '',
'KAFKA_HEAP_OPTS' => '',
'JMX_PORT'=> 9999
})
# Override
attribute(:override_sysconfig, kind_of: Hash, default: {})

### General configuration attributes for ES
# Default
attribute(:default_config, kind_of: Hash, default: {
  'num.network.threads' => 3,
  'num.io.threads' => 8,
  'socket.send.buffer.bytes' => 102400,
  'socket.receive.buffer.bytes' => 102400,
  'socket.request.max.bytes' => 104857600,
  'num.partitions' => 1,
  'num.recovery.threads.per.data.dir' => 1,
  'log.retention.hours' => 1,
  'log.segment.bytes' => 1073741824,
  'log.retention.check.interval.ms' => 300000,
  'log.cleaner.enable' => false,
  'zookeeper.connection.timeout.ms' => 6000,
  'message.max.bytes' => 22746705,
  'replica.fetch.max.bytes' => 22746705,
  'delete.topic.enable' => true
})
# Override
attribute(:override_config, kind_of: Hash, default: {})
