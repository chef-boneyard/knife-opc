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
require 'chef/mixin/root_rest'

module Opc
  class OpcUserDelete < Chef::Knife
    category "OPSCODE PRIVATE CHEF ORGANIZATION MANAGEMENT"
    banner "knife opc user delete USERNAME [-d]"

    option :no_disassociate_user,
    :long => "--no-disassociate-user",
    :short => "-d",
    :description => "Don't disassociate the user first"

    include Chef::Mixin::RootRestv0

    def run
      username = @name_args[0]
      ui.confirm "Do you want to delete the user #{username}"
      unless config[:no_disassociate_user]
         orgs =  root_rest.get("users/#{username}/organizations")
         org_names = orgs.map {|o| o['organization']['name']}
         org_names.each do |org|
            ui.output root_rest.delete("organizations/#{org}/users/#{username}")
         end
      end
      ui.output root_rest.delete("users/#{username}")
    end
  end
end
