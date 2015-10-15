require 'spec_helper'
require 'ruby_enum/rspec'

describe 'rspec matchers' do

  class SwitchState
    include RubyEnum

    enum :on, 1
    enum :off, 0
  end

  subject { SwitchState }

  it { should be_an_enumeration }
  it { should define_enumeration_value :on }
  it { should define_enumeration_value :on, 1 }
  it { should_not define_enumeration_value :on, 0 }
  it { should define_enumeration_value :off }
  it { should define_enumeration_value :off, 0 }
  it { should_not define_enumeration_value :off, 1 }
end
