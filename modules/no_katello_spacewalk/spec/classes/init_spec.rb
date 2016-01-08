require 'spec_helper'
describe 'no_subscription_manager' do

  context 'with defaults for all parameters' do
    it { should contain_class('no_subscription_manager') }
  end
end
