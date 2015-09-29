module Kafka
  module Kafka_helper
    
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

  end
end
