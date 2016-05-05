module Kafka
  module Kafka_helper
    
  require 'mixlib/shellout'


    def kafka_installed?(path, version)
      install_flag = ::File.join(path, "kafka_#{version}.jar")
      ::File.exist?(install_flag)
    end

    def render(hash,key,separator=': ',prefix='',suffix='')
      value = hash[key]
      unless value.nil?
        if value.is_a?(Array)
          return [prefix,key,separator,value.to_s,suffix,"\n"].join
        else
          return [prefix,key,separator,value.to_s,suffix,"\n"].join
        end
        return nil
      end
    end
    

    # databag e.g
    #  [{"id"=>1, "hostname"=>"default-oel65-chef-java", "status"=>"ACTIVE"}, {"id"=>2, "hostname"=>"test02", "status"=>"DECOMISSIONED"}]
    def get_active_host_hash(databag)
      hosts = databag['hosts']
      active_ensemble = hosts.reject { |c| c['status'] != 'ACTIVE' }.map { |host| host['hostname'] }
    end

   # array, string e.g ['host1','host2'] , "2181"
   # returns String e.g "host1:2181,host2:2181"
   def get_ensemble_string(hosts,port)
      hosts.map { |host| "#{host}:#{port}" }.join(',')
   end
   

   # brokers = array of hashes, e.g [{ id: '', hostname: '', status: ''}]
   # instance = node.hostname
   # return the matched id value, int
   def get_broker_id(brokers, instance)
      hosts = brokers['hosts']
      puts "hosts in helper #{hosts}"
      if host = hosts.find { |n| n['hostname'] == instance }
        return host['id']
      else
        raise "Unable to find an entry for hostname: #{instance} in data bag 'hosts' section: #{hosts}"
      end
    end

  def topic_exists?(kafka_home, zookeeper, topic)
     kafka_cmd=::File.join(kafka_home,'bin','kafka-topics.sh')
     cmd = Mixlib::ShellOut.new("#{kafka_cmd} --zookeeper #{zookeeper} --list").run_command
     stdout = cmd.stdout.empty? ? "WARN: No return output for kafka-topics --list" : cmd.stdout
     raise "Error checking for topic #{topic}: stderr=#{cmd.stderr}" unless cmd.stderr.empty?
     unless cmd.stdout.split("\n").include? topic
       puts "Topic #{topic} doesn't exist"
       return false
     end
     puts "Topic #{topic} exists"
     return true
  end 

  end
end
