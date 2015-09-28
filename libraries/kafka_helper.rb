module Kafka
  module Kafka_helper
    
    def kafka_installed?(path, version)
      # Stub this for now
      # /usr/lib/kafka/libs/kafka_2.10-0.8.2.0.jar
      install_flag = '/opt/kafka/libs/kafka_2.10-0.8.2.0.jar'
      ::File.exist?(install_flag)
    end
  end
end
