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
    end
    include Chef::Org::GroupOperations
  end
end
