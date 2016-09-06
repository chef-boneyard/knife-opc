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
  class DeleteFailed < StandardError ; end
    category "OPSCODE PRIVATE CHEF ORGANIZATION MANAGEMENT"
    banner "knife opc user delete USERNAME [-d] [-R]"

    option :no_disassociate_user,
      :long => "--no-disassociate-user",
      :short => "-d",
      :description => "Don't disassociate the user first"

    option :remove_from_admin_groups,
      long:  "--remove-from-admin-groups",
      short:  "-R",
      description: "If the user is a member of any org admin groups, attempt to remove from those groups. Ignored if --no-disassociate-user is set."

    attr_reader :username
    include Chef::Mixin::RootRestv0

    deps do
      require 'chef/org'
      require 'chef/org/group_operations'
    end

    def run
      @username = @name_args[0]
      admin_memberships = []
      unremovable_memberships = []

      ui.confirm "Do you want to delete the user #{username}"

      if config[:no_disassociate_user]
        delete_user(username)
        return
      end

      ui.output("Checking organization memberships...")
      orgs = org_memberships(username)

      if orgs.length > 0
        ui.output("Checking admin group memberships for #{orgs.length} org(s).")
        admin_memberships, unremovable_memberships = admin_group_memberships(orgs, username)
      end

      if admin_memberships.empty?
        disassociate_user(orgs, username)
        delete_user(username)
      else # Has admin memberships:
        if config[:remove_from_admin_groups]
          unless unremovable_memberships.empty?
            raise DeleteFailed.new(error_cant_remove_admin_membership(username, unremovable_memberships))
          end
          remove_from_admin_groups(admin_memberships, username)
        else
          raise DeleteFailed.new(error_admin_group_member(username,
                                                          admin_memberships))
        end
        disassociate_user(orgs, username)
        delete_user(username)
      end
    rescue DeleteFailed => e
      ui.output(e.message)
    end

    def disassociate_user(orgs, username)
      orgs.each  {|org| org.dissociate_user(username) }
    end

    def org_memberships(username)
      org_data =  root_rest.get("users/#{username}/organizations")
      org_names = org_data.map {|o| o['organization']['name']}
      orgs = []
      org_names.each { |name| orgs << Chef::Org.new(name) }
      orgs
    end

    def remove_from_admin_groups(admin_of, username)
      admin_of.each { |org| org.remove_user_from_group("admins", username) }
    end

    def admin_group_memberships(orgs, username)
      admin_of = []
      unremovable = []
      orgs.each do |org|
        if org.user_member_of_group?(username, 'admins')
          admin_of << org
          if org.actor_delete_would_leave_admins_empty?
            unremovable << org
          end
        end
      end
      [admin_of, unremovable]
    end

    def delete_user(username)
      ui.output root_rest.delete("users/#{username}")
    end
    def pluralize(word, quantity)
      case word
      when "it"
        quantity > 1 ? "them" : "it"
      else
        quantity == 1 ? word : "#{word}s"
      end
    end


    # Error message that says how to removed from org
    # admin groups before deleting
    # Further
    def error_admin_group_member(username, admin_of)
      message = "#{username} is in the 'admins' group of the following organization(s):\n\n"

      admin_of.each { |org| message << "- #{org.name}\n" }

      message << <<EOM

Run this command again with the --remove-from-admin-groups option to
remove the user from these admin group(s) automatically.

EOM
      message
    end

    def error_cant_remove_admin_membership(username, only_admin_of)
      message = <<EOM

#{username} is the only member of the 'admins' group of the
following organization(s):

EOM
        only_admin_of.each {|org| message <<  "- #{org.name}\n"}

        message << <<EOM

Removing the only administrator of an organization can break it.
Assign additional users or groups to the admin group(s) before
deleting this user.

EOM
      message
    end
  end
end
