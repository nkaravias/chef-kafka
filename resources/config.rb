actions :render
default_action :render

attribute :user, :kind_of => String, default: 'kafka'
attribute :group, :kind_of => String, default: 'kafka'

attribute :install_path, :kind_of => String, default: '/opt/kafka'
attribute :log_path, :kind_of => String, default: '/var/log/kafka'

attribute :jmx_port, :kind_of => Integer, default: 9999

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
'JVM_PORT'=> 9999
})
# Override
attribute(:override_sysconfig, kind_of: Hash, default: {})

### General configuration attributes for ES
# Default
attribute(:default_config, kind_of: Hash, default: {
  'action.destructive_requires_name' => true,
  'node.max_local_storage_nodes' => 1,
  'network.host' => '',
  'discovery.zen.ping.multicast.enabled' => false,
  'discovery.zen.ping.unicast.hosts' => '[]',
  'discovery.zen.minimum_master_nodes' => 1,
  'gateway.expected_nodes' => 1,
  'http.port' => 9200
})
# Override
attribute(:override_config, kind_of: Hash, default: {})
