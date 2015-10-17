[![Gem
Version](https://badge.fury.io/rb/ruby_enum.svg)](https://badge.fury.io/rb/ruby_enum)

[![Build
Status](https://travis-ci.org/laskaridis/ruby_enum.svg?branch=master)](https://travis-ci.org/laskaridis/ruby_enum)

# RubyEnum

A simple enumeration type for ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_enum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_enum

## Usage

To create an enumeration type include the `RubyEnum` module in your enumeration
class and provide the enumeration's values as follows:

```ruby
class Coordinate
  include RubyEnum
  
  enum :north
  enum :south
  enum :west
  enum :east
end
```
Note that you can't define the same enumeration instance twice. An error will
be raised in this case, for example:

```ruby
class InvalidEnumeration
  include RubyEnum

  enum :value
  enum :value
end
```

Including `RubyEnum` in any class will make it a singleton. You will not be able
to create new instances of your class using `new`, `allocate`, `clone` or
`dup`. You can access an enumeration's values in three different ways:

Using a class method that matches the enumeration instance name:

```ruby
north = Coordinate.north
```

Using a constant that matches the enumeration instance name:

```ruby
north = Coordinate::NORTH
```

Treating your enumeration class as a dictionary:

```ruby
north = Coordinate[:north]
```
Note that his method returns `nil` if no enumeration instance is found by the
specified name.

To retrieve all enumeration instances simply use method `all` on your
enumeration class:

```ruby
coordinates = Coordinate.all
```

### Specifying associated values

Each enumeration instance has an implicit name and associated value attributes
accessible through the `name` and `value` methods. If no associated value is
specified for an enumeration instance in the definition of the enumeration 
class, it will be implicitly set to its name:

```ruby
north = Coordinate.north
north.name
# => :north
north.value
# => "north"
```

You may provide a custom associated value to each enumeration instance following
its name in the declaration:

```ruby
class Planet
  include RubyEnum

  enum :mercury, 1
  enum :venus, 2
  enum :earth, 3
end

mercury = Planet.mercury
mercury.name
# => :mercury
mercury.value
# => 1
```

Associated values should be unique in the context of an enumeration class. An 
error will be thrown in those cases, for example:

```ruby
class InvalidEnumeration
  include RubyEnum

  enum :a, 1
  enum :b, 1
end
```

### Finding enumerations by associated value

You can find an enumeration value by its associated value:

```ruby
mercury = Planet.find_by_value 1
```

If no enumeration instance is found with the specified associated value this
method returns `nil`. Using the `find_by_value!` version, an error is raised in
this case.

### Testing enumeration classes

To test enumeration classes you can use the custom `be_an_enumeration` and
`define_enumeration_value` matchers.

```ruby
require 'ruby_enum/rspec'

describe Coordinate do

  it { should be_an_enumeration }
  it { should define_enumeration_value :north }
  it { should define_enumeration_value :north, 'north' }
end
```

### Adding custom methods

Nothing stops you from adding your own methods to an enumeration.

```ruby
class Planet
  include RubyEnum

  enum :mercury, 1
  enum :venus, 2
  enum :earth, 3

  def description
    "#{name.to_s.capitalize} is the #{value.ordinalize} rock from the sun"
  end
end

mercury = Planet::EARTH
mercury.description
# => "Earth is the 3rd rock from the sun"
```

## Contributing

1. Fork it ( https://github.com/laskaridis/ruby_enum/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
