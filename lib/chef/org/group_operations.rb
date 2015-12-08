require 'chef/org'

class Chef
  class Org
    module GroupOperations
      def add_user_to_group(groupname, username)
        group = chef_rest.get_rest "organizations/#{name}/groups/#{groupname}"
        body_hash = {
          :groupname => "#{groupname}",
          :actors => {
            "users" => group["actors"].concat([username]),
            "groups" => group["groups"]
          }
        }
        chef_rest.put_rest "organizations/#{name}/groups/#{groupname}", body_hash
      end

      def remove_user_from_group(groupname, username)
        group = chef_rest.get_rest "organizations/#{name}/groups/#{groupname}"
        group['actors'].delete(username)
        body_hash = {
          :groupname => "#{groupname}",
          :actors => {
            "users" => group["actors"],
            "groups" => group["groups"]
          }
        }
        chef_rest.put_rest "organizations/#{name}/groups/#{groupname}", body_hash
      end

      def actor_delete_would_leave_admins_empty?
        group = chef_rest.get_rest "organizations/#{name}/groups/admins"
        # pivotal should not factor into this check
        group['actors'].delete('pivotal')
        group['actors'].length <= 1 && group['groups'].empty?
      end
    end
    include Chef::Org::GroupOperations
  end
end
