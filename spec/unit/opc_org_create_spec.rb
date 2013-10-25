require File.expand_path('../../spec_helper', __FILE__)

describe Opc::OpcOrgCreate do
  before :each do
    @knife = Chef::Knife::OpcOrgCreate.new
    @stdout = StringIO.new
    @stderr = StringIO.new
    @knife.ui.stub(:stdout).and_return(@stdout)
    @knife.ui.stub(:stderr).and_return(@stderr)
  end

  describe 'with no org_name and org_fullname' do
    it 'should fail with message' do
      @knife.ui.should_receive(:fatal).with("You must specify an ORG_NAME and an ORG_FULL_NAME")
      @knife.should_receive(:show_usage)
      lambda { @knife.run }.should raise_error( SystemExit )
    end
  end
end