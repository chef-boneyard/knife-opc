require "spec_helper"
require "chef/knife/opc_user_list"

describe Opc::OpcUserList do

  let(:users) do
    {
     "test_user1" => {
        "email": "test_user1@example.com",
        "first_name": "Test",
        "last_name": "User1",
        "display_name": "Test User1",
      },
      "test_user2" => {
        "email": "agupta@example.com",
        "first_name": "Test",
        "last_name": "User2",
        "display_name": "Test User2",
      },

    }
  end

  before :each do
    @rest = double("Chef::ServerAPI")
    allow(Chef::ServerAPI).to receive(:new).and_return(@rest)
    allow(@rest).to receive(:get).with("users").and_return(users)
    @knife = Chef::Knife::OpcUserList.new
  end

  describe "with no arguments" do
    it "lists all user" do
      expect(@knife.ui).to receive(:output).with(%w{test_user1 test_user2})
      @knife.run
    end
  end

  describe "list user with_uri argument" do
    let(:users) do
      {
       "test_user1" =>  "https://example.com/organizations/test_org1/users/test_user1",
       "test_user2" => "https://example.com/organizations/test_org2/users/test_user2",
      }
    end

    before do
      @knife.config[:with_uri] = true
    end

    it "lists all user with corresponding URIs" do
      expect(@knife.ui).to receive(:output).with(users)
      @knife.run
    end
  end

  describe "with all_info argument" do
    before do
      allow(@rest).to receive(:get).with("users?verbose=true").and_return(users)
      @knife.config[:all_info] = true
    end

    it "list all user with more detail about a user" do
      expect(@knife.ui).to receive(:output).with(users)
      @knife.run
    end
  end
end
