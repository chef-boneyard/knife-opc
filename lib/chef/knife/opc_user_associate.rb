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
  class OpcUserAssociate < Chef::Knife
    category "OPSCODE PRIVATE CHEF ORGANIZATION MANAGEMENT"
    banner "knife opc user associate USERNAME ORGNAME"

    def run
      case @name_args.count
      when 2
        username, orgname = @name_args
      else
        ui.fatal "Wrong number of arguments"
        show_usage
        exit 1
      end
      @chef_rest = Chef::REST.new(Chef::Config[:chef_server_root])

      request_body = {:user => username}
      response = @chef_rest.post_rest "organizations/#{config[:orgname]}/association_requests", request_body
      association_id = response["uri"].split("/").last
      @chef_rest.put_rest "users/#{username}/association_requests/#{association_id}", { :response => 'accept' }

    end
  end
end
