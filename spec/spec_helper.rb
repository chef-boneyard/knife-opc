$:.unshift File.expand_path('../../lib', __FILE__)
require 'chef/knife'
require 'chef/knife/opc_org_list'

class Chef::Knife
  include Opc
end

