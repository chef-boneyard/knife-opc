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
  class OpcUserList < Chef::Knife
    category "CHEF ORGANIZATION MANAGEMENT"
    banner "knife opc user list"

    option :with_uri,
      long: "--with-uri",
      short: "-w",
      description: "Show corresponding URIs"

    option :all_info,
      long: "--all-info",
      short: "-a",
      description: "Show corresponding details i.e. username, email, first_name, last_name, display_name"

    include Chef::Mixin::RootRestv0

    def run
      if config[:all_info]
        results = root_rest.get("users?verbose=true")
        ui.output format_user_list(results)
      else
        results = root_rest.get("users")
        ui.output(ui.format_list_for_display(results))
      end
    end

    private

    def format_user_list(users)
      final_list = []
      users.each do |username, user_info|
        user_list = {}
        user_list[:username] = username
        user_list = user_list.merge(user_info)
        final_list.push(user_list)
      end
      final_list
    end
  end
end
