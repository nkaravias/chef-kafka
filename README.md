# omc_kafka Cookbook

Installs and configures a kafka broker. The cookbook follows the library pattern and exposes two custom resources (LWRP):
* omc_kafka_node (Installs the broker software)
* omc_kafka_config (Configures the kafka broker and ensures the service is running)

## Requirements

Third party cookbook dependencies:
* java (https://supermarket.chef.io/cookbooks/java)

#Data bags:
* Kafka requires a zookeeper ensemble to be active. This is not handled by this cookbook (check the omc_zookeeper cookbook). All zookeeper nodes much get added to the data bag item that gets passed to the omc_kafka_config resource as the ensemble_data_bag_info hash attribute. The data bag item should look like this:
```json
{
 "id": "zookeeper_localdev",
 "environment": "localdev",
 "use": "slapchop",
 "hosts": [{ "id": 1, "hostname": "default-oel65-chef-java", "status": "ACTIVE" },{ "id":2, "hostname": "test02" , "status": "DECOMISSIONED" },{ "id":3, "hostname": "test03" , "status": "DECOMISSIONED" }]
}
```
Short breakdown of the hosts hash contents and usage:
<table>
  <tr>
    <th>Key</th>
    <th>Value description</th>
  </tr>
  <tr>
    <td>id</td>
    <td>The zookeeper node id (0-255) should be used and be considered immutable. This value cannot be reused in an active ensemble</td>
  </tr>
  <tr>
    <td>hostname</td>
    <td>The FQDN of the zookeeper node</td>
  </tr>  
  <tr>
    <td>Status</td>
    <td>The state of the zookeeper node. If it is a member of a live ensemble then the value should be ACTIVE. In any other case set to any string but ACTIVE, e.g DECOMISSIONED, INVALID. When adding a net new node you should never be using the same myid</td>
  </tr>  
</table>


* Each kafka broker should be added in the data bag item that gets passed to the omc_kafka_config resource as the broker_data_bag_info hash attribute. The data bag item should look like this:

```json
{
 "id": "kafka_localdev",
 "environment": "localdev",
 "use": "slapchop",
 "hosts": [{ "id": 1, "hostname": "default-oel65-chef-java", "status": "ACTIVE" },{ "id":2, "hostname": "test02" , "status": "DECOMISSIONED" },{ "id":3, "hostname": "test03" , "status": "DECOMISSIONED" }]
}
```
Short breakdown of the hosts hash contents and usage:
<table>
  <tr>
    <th>Key</th>
    <th>Value description</th>
  </tr>
  <tr>
    <td>id</td>
    <td>The kafka broker id hould be used and be considered immutable. </td>
  </tr>
  <tr>
    <td>hostname</td>
    <td>The FQDN of the kafka broker</td>
  </tr>  
  <tr>
    <td>Status</td>
    <td>The state of the kafka broker. If it is a member of a live kafka cluster then the value should be ACTIVE. In any other case set to any string but ACTIVE, e.g DECOMISSIONED, INVALID. When adding a net new node you should never be using the same broker id</td>
  </tr>  
</table>


## Attributes

The following resource attributes can get overridden by a wrapper cookbook or an environment / role:
```
  home [String] location of the broker user $HOME
  source_url [String] The location of the kafka binary package
  kafka_version [String]
  scala_version [String]
  install_path [String]
  log_path [String]
  listen_port [Integer] Broker TCP listen port
  broker_data_bag_info [Hash] key: data bag with kafka host information value: data bag item
  ensemble_data_bag_info [Hash] key: data bag with zookeeper host information value: data bag item
  java_opts [Hash] Default kafka JVM values    
  override_java_opts [Hash] Override for default kafka JVM values
  default_config [Hash] Default kafka configuration values
  override_config [Hash] Override for default kafka configuration values
  default_sysconfig [Hash] Default kafka sysconfig values
  override_sysconfig [Hash] Override for sysconfig kafka values
```
In regards to various configuration values (sysconfig, java_opts, config) this resource is using generic default values for each use case (e.g default_sysconfig hash). If you simply need to change one of the default values there's two options:
* Override the whole default_sysconfig hash.
* Simply add a new key on the override_sysconfig hash.
This allows for added flexibility when using this custom resource.

Here are the default configuration values for reference:
```ruby
attribute(:java_opts, kind_of: Hash, default: {
'-Xmx' => '512m',
'-Xms' => '256m',
'-Xss' => '256k',
'-Djava.awt.headless='=>true,
'-XX:+CMSClassUnloadingEnabled' => '',
'-XX:+CMSScavengeBeforeRemark' => '',
'-XX:+DisableExplicitGC' => '',
'-XX:+UseG1GC' => '',
'-XX:MaxGCPauseMillis=' => '20',
'-XX:InitiatingHeapOccupancyPercent=' => '35',
'-Djava.net.preferIPv4Stack=' => true,
'-Dfile.encoding=' => 'UTF-8'
})

attribute(:default_sysconfig, kind_of: Hash, default: {
'KAFKA_HOME' => '',
'KAFKA_JVM_PERFORMANCE_OPTS' => '',
'KAFKA_HEAP_OPTS' => '',
'JMX_PORT'=> 9999
})

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
```
## Usage

Check omc_kafka::default for an example use case that creates and configures a single broker kafka cluster

## Contributing

1. Create a named feature branch (adding any relevant Jira ID as a prefix is the recommended approach).
2. Write your change
3. Write tests for your change (Unit / Integration if applicable)
4. Run the tests, ensuring they all pass
5. Submit a Pull Request
