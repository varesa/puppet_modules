require 'spec_helper'
describe 'pulp_client_setup' do

  context 'with defaults for all parameters' do
    it { should contain_class('pulp_client_setup') }
  end
end
