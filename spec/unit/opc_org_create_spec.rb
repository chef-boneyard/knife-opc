require File.expand_path('../../spec_helper', __FILE__)

describe Opc::OpcOrgCreate do
  before :each do
    @knife = Chef::Knife::OpcOrgCreate.new
    @rest = double('Chef::REST')
    Chef::REST.stub(:new).and_return(@rest)
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
    it 'should fail with message' do
      @knife.ui.should_receive(:fatal).with("You must specify an ORG_NAME and an ORG_FULL_NAME")
      @knife.should_receive(:show_usage)
      lambda { @knife.run }.should raise_error( SystemExit )
    end
  end

  describe 'with org_name and org_fullname' do
    before :each do
      @knife.name_args << @org_name << @org_full_name
    end

    it 'should create an org' do
      @rest.should_receive(:post_rest).with('organizations/', org_args).and_return(result)
      @knife.ui.should_receive(:msg).with(result['private_key'])
      @knife.run
    end

    context 'and associate user' do
      before :each do
        @knife.config[:association_user] = 'ramsay'
      end

      it 'should create org and associate user' do
        @rest.should_receive(:post_rest).with('organizations/', org_args).and_return(result)
        @knife.should_receive(:associate_user).with('ramsay')
        @knife.run
      end
    end
  end
end
