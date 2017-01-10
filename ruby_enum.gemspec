# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_enum/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby_enum"
  spec.version       = "#{RubyEnum::VERSION}"
  spec.authors       = ["Lefteris Laskaridis"]
  spec.email         = ["l.laskaridis@pamediakopes.gr"]

  spec.summary       = %q{Simple enumeration type for ruby}
  spec.description   = %q{Implementation of a simple enumeration type for ruby}
  spec.homepage      = "https://github.com/laskaridis/ruby_enum"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4"
  spec.add_dependency "railties", "~> 4"

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3.0"
  spec.add_development_dependency 'rails', '~> 4.2.0'
  spec.add_development_dependency "sqlite3"
end
