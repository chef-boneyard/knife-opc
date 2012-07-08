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
  class OpcUserCreate < Chef::Knife
    category "OPSCODE PRIVATE CHEF ORGANIZATION MANAGEMENT"
    banner "knife opc user create USERNAME FIRST_NAME [MIDDLE_NAME] LAST_NAME EMAIL PASSWORD"

    option :filename,
    :long => '--filename FILENAME',
    :short => '-f FILENAME'

    def run
      case @name_args.count
      when 6
        username, first_name, middle_name, last_name, email, password = @name_args
      when 5
        username, first_name, last_name, email, password = @name_args
      else
        ui.fatal "Wrong number of arguments"
        show_usage
        exit 1
      end
      middle_name ||= ""

      user_hash = {
        :username =>     username,
        :first_name =>   first_name,
        :middle_name =>  middle_name,
        :last_name =>    last_name,
        :display_name => "#{first_name} #{last_name}",
        :email =>        email,
        :password =>     password
      }

      @chef_rest = Chef::REST.new(Chef::Config[:chef_server_root])
      result = @chef_rest.post_rest("users/", user_hash)
      if config[:filename]
        File.open(config[:filename], "w") do |f|
          f.print(result['private_key'])
        end
      else
        ui.msg result['private_key']
      end
    end
  end
end
