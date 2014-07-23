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
    rest_class = double('rest_class')
    @rest = double('Chef::REST')
    stub_const("Chef::REST", rest_class)
    allow(rest_class).to receive(:new).and_return(@rest)
    allow(@rest).to receive(:get_rest).with('organizations').and_return(orgs)
    @knife = Chef::Knife::OpcOrgList.new
  end

  describe 'with no arguments' do
    it 'lists all non hidden orgs' do
      expect(@knife.ui).to receive(:output).with(['org1','org2'])
      @knife.run
    end

  end

  describe 'with all_orgs argument' do
    before do
      @knife.config[:all_orgs] = true
    end

    it 'lists all orgs including hidden orgs' do
      expect(@knife.ui).to receive(:output).with(['hiddenhiddenhiddenhi','org1','org2'])
      @knife.run
    end
  end
end
