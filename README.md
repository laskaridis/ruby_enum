[![Gem
Version](https://badge.fury.io/rb/ruby_enum.svg)](https://badge.fury.io/rb/ruby_enum)

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

To create an enumeration type simply include the `RubyEnum` module in your
enumeration class and provide the enumeration's values as follows:
```ruby
class Coordinates
  include RubyEnum
  
  enum :north
  enum :south
  enum :west
  enum :east
```

Including `RubyEnum` in any class will make it a singleton. This means that you
can't create new instances of your class using `new`, `allocate`, `clone` or
`dup`. You can access an enumeration's value instances in three different ways:

1. Using a class method that matches the provided name of the enumeration
value:
```ruby
north = Coordinates.north
```

2. Using a constant:
```ruby
north = Coordinates::NORTH
```

3. Treating your enumeration class as a dictionary:
```ruby
north = Coordinates[:north]
```

All three approaches are equivalent and subject to personal style.

To retrieve all values of an enumeration, simply invoke `all` method on your
enumeration class:
```ruby
coordinates = Coordinates.all
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ruby_enum/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
