require File.expand_path('../../spec_helper', __FILE__)

describe Opc do

  let(:orgs) do
    {
      'org1' => 'first',
      'org2' => 'second'
    }
  end

  before :each do
    @rest = double('Chef::REST')
    Chef::REST.should_receive(:new).and_return(@rest)
    @rest.should_receive(:get_rest).with('organizations').and_return(orgs)
    @knife = Chef::Knife::OpcOrgList.new
  end

  describe 'should list all org' do    
    it do
      @knife.ui.should_receive(:output).with(['org1','org2'])
      @knife.run
    end
  end
end
