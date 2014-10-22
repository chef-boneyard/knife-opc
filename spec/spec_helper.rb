$:.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
require 'chef/knife'
require 'chef/knife/opc_org_list'
require 'chef/knife/opc_org_create'


SimpleCov.start do
   add_filter "/spec/"
   add_filter "/vendor/"
end


class Chef::Knife
  include Opc
end
