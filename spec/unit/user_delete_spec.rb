require "spec_helper"
require "chef/knife/opc_user_delete"

describe Opc::OpcUserDelete do

  subject(:knife) { Chef::Knife::OpcUserDelete.new }

  before :each do
    @orgs = [
              { "organization" => { "name" => "testorg" } },
            ]
    @rest = double("Chef::ServerAPI")
    allow(Chef::ServerAPI).to receive(:new).and_return(@rest)
    knife.name_args = ["testuser"]
  end

  it "deletes the testuser" do
    expect(knife.ui).to receive(:confirm).with("Do you want to delete the user testuser").and_return("Y")
    allow(@rest).to receive(:get).with("users/testuser/organizations").and_return(@orgs)
    expect(@rest).to receive(:delete).with("organizations/testorg/users/testuser")
    expect(@rest).to receive(:delete).with("users/testuser")
    knife.run
  end

  it "doesn't delete the user to admins groups" do
    expect(knife.ui).to receive(:confirm).with("Do you want to delete the user testuser").and_return("Y")
    allow(@rest).to receive(:get).with("users/testuser/organizations").and_return(@orgs)
    allow(@rest).to receive(:delete).with("organizations/testorg/users/testuser").and_raise(Net::HTTPServerException.new(nil, double({ code: "403", body: "{\"error\":\"Please remove testuser from this organization's admins group before removing him or her from the organization.\"}" })))
    expect(knife.ui).to receive(:error).with("Error removing user testuser from organization testorg due to user being in that organization's admins group.")
    expect(knife.ui).to receive(:msg).with("Please remove testuser from the admins group for testorg before deleting the user.")
    expect(knife.ui).to receive(:msg).with("This can be accomplished by passing --force to the org user remove command.")
    knife.run
  end
end
