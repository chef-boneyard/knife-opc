#
# Author:: Steven Danna (<steve@opscode.com>)
# Copyright:: Copyright 2011 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Opc
  class OpcOrgCreate < Chef::Knife
    category "OPSCODE PRIVATE CHEF ORGANIZATION MANAGEMENT"
    banner "knife opc org create ORG_SHORT_NAME ORG_FULL_NAME (options)"

    option :filename,
    :long => '--filename FILENAME',
    :short => '-f FILENAME'

    option :association_user,
    :long => '--association_user USERNAME',
    :short => '-a USERNAME'

    attr_accessor :org_name, :org_full_name

    def run
      @org_name, @org_full_name = @name_args

      if !org_name || !org_full_name
        ui.fatal "You must specify an ORG_NAME and an ORG_FULL_NAME"
        show_usage
        exit 1
      end

      org_args = { :name => org_name, :full_name => org_full_name}
      @chef_rest = Chef::REST.new(Chef::Config[:chef_server_root])
      result = @chef_rest.post_rest("organizations/", org_args)
      if config[:filename]
        File.open(config[:filename], "w") do |f|
          f.print(result['private_key'])
        end
      else
        ui.msg result['private_key']
      end
      associate_user config[:association_user] if config[:association_user]
    end

    def associate_user(username)
      request_body = {:user => username}
      response = @chef_rest.post_rest "organizations/#{org_name}/association_requests", request_body
      association_id = response["uri"].split("/").last
      @chef_rest.put_rest "users/#{username}/association_requests/#{association_id}", { :response => 'accept' }
    end

  end
end
