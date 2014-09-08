#
# Author:: Marc Paradise (<marc@getchef.com>)
# Copyright:: Copyright 2014 Chef Software, Inc
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
  class OpcOrgDissociate < Chef::Knife
    category "OPSCODE PRIVATE CHEF ORGANIZATION MANAGEMENT"
    banner "knife opc org dissociate ORG_NAME USER_NAME"
    attr_accessor :org_name, :username

    def run
      @org_name, @username = @name_args

      if !org_name || !username
        ui.fatal "You must specify an ORG_NAME and USER_NAME"
        show_usage
        exit 1
      end

      @chef_rest = Chef::REST.new(Chef::Config[:chef_server_root])
      response = @chef_rest.delete_rest "organizations/#{org_name}/users/#{username}"
      if response["error"]
        ui.msg response["error"]
      else
        ui.msg "User #{username} has been dissociated from organization #{org_name}"
      end
    end
  end
end
