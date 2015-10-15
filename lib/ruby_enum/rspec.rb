require 'rspec/expectations'

RSpec::Matchers.define :be_an_enumeration do
  match do |actual|
    actual.ancestors.include? RubyEnum
  end
end

RSpec::Matchers.define :define_enumeration_value do |name, value|
  match do |actual|
    enum_value = actual.send name
    if value
      enum_value.name == name && enum_value.value == value
    else
      enum_value.name == name
    end
  end
  description do
    if value
    "define enumeration #{name} with value #{value}"
    else
    "define enumeration #{name}"
    end
  end
end
