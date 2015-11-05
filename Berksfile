source "https://supermarket.chef.io"

metadata

cookbook 'java', '~> 1.35.0'
cookbook 'omc_zookeeper', path: '../omc_zookeeper'

group :integration do
  cookbook 'omc_zookeeper_test', path: 'test/fixtures/cookbooks/omc_zookeeper_test'
  cookbook 'omc_kafka_test', path: 'test/fixtures/cookbooks/omc_kafka_test'
end
