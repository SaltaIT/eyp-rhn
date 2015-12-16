require 'spec_helper'
describe 'rhn' do

  context 'with defaults for all parameters' do
    it { should contain_class('rhn') }
  end
end
