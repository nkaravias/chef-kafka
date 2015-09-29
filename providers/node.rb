Chef::Resource::RemoteFile.send(:include, Kafka::Kafka_helper)
Chef::Resource::Execute.send(:include, Kafka::Kafka_helper)
Chef::Resource::Link.send(:include, Kafka::Kafka_helper)

use_inline_resources

def whyrun_supported?
   true
end

action :install do
  node_name = new_resource.name
  version = "#{new_resource.scala_version}-#{new_resource.kafka_version}"  

  archive = "kafka_#{version}"
  local_archive_path = ::File.join(Chef::Config[:file_cache_path], "#{archive}.tgz")
  install_root = ::File.expand_path('..', new_resource.install_path)

  group new_resource.group do
    action :create
    system true
  end

  user new_resource.user do
    home  new_resource.home
    shell  new_resource.shell
    gid  new_resource.group
    supports manage_home: false
    action  :create
    system true
  end

  download_package(local_archive_path, new_resource.source_url)
  extract_package(archive, local_archive_path, install_root)
  create_link(::File.join(install_root, archive), new_resource.install_path)
  [ new_resource.log_path ].each do |dir|
    create_directory(dir, new_resource.user, new_resource.group)
  end
end

def download_package(source, url)
  lib_path = ::File.join(current_resource.install_path,'libs')
  version = "#{new_resource.scala_version}-#{new_resource.kafka_version}"
  remote_file source do
    source url
    owner new_resource.user
    group new_resource.group
    mode '0644'
    not_if { kafka_installed?(lib_path, version) }
  end
end


def extract_package(name,source,destination)
  lib_path = ::File.join(current_resource.install_path,'libs')
  version = "#{new_resource.scala_version}-#{new_resource.kafka_version}"
  execute "Extract #{name} to #{destination}" do
    cwd destination
    command "tar zxvf #{source} -C .; chown #{new_resource.user}:#{new_resource.group} ./#{name}* -R"
    action :run
    not_if { kafka_installed?(lib_path, version) }
  end
end

def create_link(source,target)
  lib_path = ::File.join(current_resource.install_path,'libs')
  version = "#{new_resource.scala_version}-#{new_resource.kafka_version}"
  link target do
    to source
    owner new_resource.user
    group new_resource.group
    not_if { kafka_installed?(lib_path, version) }
  end
end

def create_directory(path, owner, group)
  directory path do
    owner owner
    group group
    mode '0755'
    recursive true
    action :create
  end
end

def load_current_resource
  @current_resource = Chef::Resource::OmcKafkaNode.new(@new_resource.name)
  @current_resource.user(@new_resource.user)
  @current_resource.group(@new_resource.group)
  @current_resource.shell(@new_resource.shell)
  @current_resource.home(@new_resource.home)
  @current_resource.source_url(@new_resource.source_url)
  @current_resource.kafka_version(@new_resource.kafka_version)
  @current_resource.scala_version(@new_resource.scala_version)
  @current_resource.install_path(@new_resource.install_path)
  #@current_resource.data_path(@new_resource.data_path)
  @current_resource.log_path(@new_resource.log_path)
  #@current_resource.config_path(@new_resource.config_path)
end
