use_inline_resources

def whyrun_supported?
  true
end

action :render do
  service 'kafka' do
    supports :restart => true, :start => true, :stop => true, :reload => true
    action :nothing
  end
=begin
=end
   
  default_sysconfig= new_resource.default_sysconfig.merge!(new_resource.override_sysconfig)
  # After the merge apply global attributes
  default_sysconfig['KAFKA_HOME']=new_resource.install_path
  # merge all java_opts and set as KAFKA_JVM_PERFOMANCE_OPTS 
  default_sysconfig['KAFKA_JVM_PERFORMANCE_OPTS']=new_resource.java_opts.merge!(new_resource.override_java_opts)
  jvm_opts = default_sysconfig['KAFKA_JVM_PERFORMANCE_OPTS']
  # HEAP_OPTS is generated from JAVA_OPTS['-Xmx'] & JAVA_OPTS['-Xms'] & JAVA_OPTS['-Xss']
  # If any of those keys has been overriden and is nil or has a nil value - raise an exception
  # else remove from KAFKA_JVM_PERFORMANCE_OPTS and add in key KAFKA_HEAP_OPTS
  heap_keys = [ '-Xmx', '-Xms', '-Xss' ]
  if heap_keys.all? { |key| jvm_opts.key? key }
     kafka_heap_opts = {}
     heap_keys.each do |option|
        kafka_heap_opts[option] = jvm_opts[option]
     end
     default_sysconfig['KAFKA_HEAP_OPTS'] = kafka_heap_opts
     # Now remove those keys from KAFKA_JVM_PERFORMANCE_OPTS since they're already on KAFKA_HEAP_OPTS
     heap_keys.each { |key| jvm_opts.delete(key) }
  else
    raise "The required heap options (-Xmx, -Xms, -Xss) did not get  set. Check the java_opts & override_java_opts attributes"
  end 
  #default_sysconfig['KAFKA_JVM_PERFORMANCE_OPTS'] = jvm_opts
  # debug
  #
  puts "Merged SYSCONFIG values:#{default_sysconfig}\n"
  #puts "KAFKA_JVM_PERFORMANCE_OPTS"
  #puts default_sysconfig['KAFKA_JVM_PERFORMANCE_OPTS']

  template "Kafka sysconfig parameters" do
    path '/etc/sysconfig/kafka'
    source 'etc/sysconfig/kafka.erb'
    owner new_resource.user
    group new_resource.group
    mode '0644'
    cookbook 'omc_kafka'
    helpers(Kafka::Kafka_helper)
    variables(:config => default_sysconfig)
    notifies :enable,"service[kafka]"
    notifies :restart,"service[kafka]"
  end

=begin
  default_config = new_resource.default_config
  # Add global attributes
  default_config['path.log']=new_resource.log_path
  
  merged_configuration = default_config.merge(new_resource.override_config)
  # Write checks after the merge... to make sure globals aren't overriden...
=end
  # debug
  #puts "Default config values:#{default_config}\n"
  #puts "Overriden config values:#{new_resource.override_config}\n"
  #puts "Merged config values:#{merged_configuration}\n"
  template "Kafka configuration" do
    path ::File.join(new_resource.install_path, 'config', 'server.properties')
    source 'config/server.properties.erb'
    owner new_resource.user
    group new_resource.group
    mode '0644'
    helpers(Kafka::Kafka_helper)
    cookbook 'omc_kafka'
    #variables(:config => merged_configuration)
    #notifies :enable,"service[kafka]"
    #notifies :restart,"service[kafka]"
  end

  template "Init.d script for kafka" do
    path '/etc/init.d/kafka'
    source 'etc/initd/kafka.erb'
    owner new_resource.user
    group new_resource.group
    mode '0755'
    cookbook 'omc_kafka'
    notifies :enable,"service[kafka]"
    notifies :restart,"service[kafka]"
  end
end
def load_current_resource
  @current_resource = Chef::Resource::OmcKafkaConfig.new(@new_resource.name)
  @current_resource.user(@new_resource.user)
  @current_resource.group(@new_resource.group)
  @current_resource.install_path(@new_resource.install_path)
  #@current_resource.java_opts(@new_resource.java_opts)
  @current_resource.java_opts(@new_resource.java_opts)
  @current_resource.override_java_opts(@new_resource.override_java_opts)
  @current_resource.default_config(@new_resource.default_config)
  @current_resource.override_config(@new_resource.override_config)
  @current_resource.default_sysconfig(@new_resource.default_sysconfig)
  @current_resource.override_sysconfig(@new_resource.override_sysconfig)
end
