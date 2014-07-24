require File.expand_path('../../spec_helper', __FILE__)

describe Opc::OpcOrgCreate do
  before :each do
    @knife = Chef::Knife::OpcOrgCreate.new
    @rest = double('Chef::REST')
    allow(Chef::REST).to receive(:new).and_return(@rest)
    @org_name = 'ss'
    @org_full_name = 'secretsauce'
  end

  let(:org_args) do
    {
      :name => @org_name,
      :full_name => @org_full_name
    }
  end

  let(:result) do
    {
      :private_key => "You don't come into cooking to get rich - Ramsay"
    }
  end

  describe 'with no org_name and org_fullname' do
    it 'fails with an informative message' do
      expect(@knife.ui).to receive(:fatal).with("You must specify an ORG_NAME and an ORG_FULL_NAME")
      expect(@knife).to receive(:show_usage)
      expect{ @knife.run }.to raise_error(SystemExit)
    end
  end

  describe 'with org_name and org_fullname' do
    before :each do
      @knife.name_args << @org_name << @org_full_name
    end

    it 'creates an org' do
      expect(@rest).to receive(:post_rest).with('organizations/', org_args).and_return(result)
      expect(@knife.ui).to receive(:msg).with(result['private_key'])
      @knife.run
    end

    context 'with --assocation-user' do
      before :each do
        @knife.config[:association_user] = 'ramsay'
      end

      it 'creates an org and associates a user' do
        expect(@rest).to receive(:post_rest).with('organizations/', org_args).and_return(result)
        expect(@knife.ui).to receive(:msg).with(result['private_key'])
        expect(@knife).to receive(:associate_user).with('ramsay')
        @knife.run
      end
    end
  end
end
