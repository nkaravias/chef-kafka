# -*- coding: utf-8 -*-

require 'serverspec'
require 'pathname'
require 'net/http'
require 'net/smtp'
require 'json'

set :backend, :exec
set :path, '$PATH:/sbin:/usr/sbin:/usr/bin:/bin'

#$node = ::JSON.parse(File.read('/tmp/serverspec/node.json'))
basedir = '/tmp/kitchen/environments'
filename = '*.json'
node_file =  Dir["#{basedir}/#{filename}*"].first
$node = ::JSON.parse(File.read(node_file))
$node = $node['default_attributes'].merge($node['override_attributes'])

