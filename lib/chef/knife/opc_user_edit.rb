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
  class OpcUserEdit < Chef::Knife
    category "OPSCODE PRIVATE CHEF ORGANIZATION MANAGEMENT"
    banner "knife opc user edit USERNAME"

    def run
      user_name = @name_args[0]

      if user_name.nil?
        show_usage
        ui.fatal("You must specify a user name")
        exit 1
      end

      @chef_rest = Chef::REST.new(Chef::Config[:chef_server_root])
      original_user =  @chef_rest.get_rest("users/#{user_name}")
      edited_user = edit_data(original_user)
      if original_user != edited_user
        @chef_rest = Chef::REST.new(Chef::Config[:chef_server_root])
        ui.msg edited_user
        result = @chef_rest.put_rest("users/#{user_name}", edited_user)
        ui.msg("Saved #{user_name}.")
      else
        ui.msg("User unchaged, not saving.")
      end

    end
  end
end