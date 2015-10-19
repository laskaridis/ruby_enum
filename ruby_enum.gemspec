# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_enum/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby_enum"
  spec.version       = "0.5.0.beta3"
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

  spec.add_dependency "activesupport", ">= 3.2"
  spec.add_dependency "railties", ">= 3.2"

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3.0"
end
