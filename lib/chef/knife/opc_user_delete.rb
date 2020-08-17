#
# Author:: Steven Danna (<steve@chef.io>)
# Copyright:: Copyright 2011-2016 Chef Software, Inc.
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
require_relative "../mixin/root_rest"

module Opc
  class OpcUserDelete < Chef::Knife
    category "OPSCODE PRIVATE CHEF ORGANIZATION MANAGEMENT"
    banner "knife opc user delete USERNAME"

    deps do
      require "chef/json_compat"
    end

    include Chef::Mixin::RootRestv0

    def run
      username = @name_args[0]
      ui.confirm "Do you want to delete the user #{username}"

      orgs = root_rest.get("users/#{username}/organizations")
      org_names = orgs.map { |o| o["organization"]["name"] }
      org_names.each do |org|
        begin
          ui.output root_rest.delete("organizations/#{org}/users/#{username}")
        rescue Net::HTTPServerException => e
          body = Chef::JSONCompat.from_json(e.response.body)
          if e.response.code == "403" && body["error"] == "Please remove #{username} from this organization's admins group before removing him or her from the organization."
            ui.error "Error removing user #{username} from organization #{org} due to user being in that organization's admins group."
            ui.msg "Please remove #{username} from the admins group for #{org} before deleting the user."
            ui.msg "This can be accomplished by passing --force to the org user remove command."
            exit 1
          else
            raise e
          end
        end
      end

      ui.output root_rest.delete("users/#{username}")
    end
  end
end
