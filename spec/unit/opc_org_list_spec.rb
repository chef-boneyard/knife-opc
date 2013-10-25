require File.expand_path('../../spec_helper', __FILE__)

describe Opc::OpcOrgList do

  let(:orgs) do
    {
      'org1' => 'first',
      'org2' => 'second',
      'hiddenhiddenhiddenhi' => 'hidden'
    }
  end

  before :each do
    @rest = double('Chef::REST')
    Chef::REST.should_receive(:new).and_return(@rest)
    @rest.should_receive(:get_rest).with('organizations').and_return(orgs)
    @knife = Chef::Knife::OpcOrgList.new
  end

  describe 'with no arguments' do
    it 'should list all non hidden orgs' do
      @knife.ui.should_receive(:output).with(['org1','org2'])
      @knife.run
    end

  end

  describe 'with all_orgs argument' do
    before do
      @knife.config[:all_orgs] = true
    end

    it 'should list all orgs including hidden orgs' do
      @knife.ui.should_receive(:output).with(['hiddenhiddenhiddenhi','org1','org2'])
      @knife.run
    end
  end
end
