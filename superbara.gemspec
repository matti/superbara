# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "superbara/version"

Gem::Specification.new do |spec|
  spec.name          = "superbara"
  spec.version       = Superbara::VERSION
  spec.authors       = ["Matti Paksula"]
  spec.email         = ["matti.paksula@iki.fi"]

  spec.summary       = %q{Super Capybara}
  spec.description   = %q{Better way to build Capybara tests}
  spec.homepage      = "https://www.github.com/matti/superbara"
  spec.license       = "MIT"

  spec.files         = `if [ -d '.git' ]; then git ls-files -z; fi`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.files += Dir['vendor/**/*']

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'colorize', '~> 0.8', '>= 0.8.1'
  spec.add_dependency 'pry'
  spec.add_dependency 'pry-stack_explorer'

  spec.add_dependency 'pry-byebug', '~> 3.6', '>= 3.6.0'
  spec.add_dependency 'binding_of_caller', '~> 0.8', '>=0.8.0'
  spec.add_dependency 'capybara', '3.29', '3.29.0'
  spec.add_dependency 'selenium-webdriver', '4.0.0.alpha3', '4.0.0.alpha3'
  spec.add_dependency 'faker', '~> 1.8', '>= 1.8.7'
  spec.add_dependency 'sinatra', '>= 2.0.1', '< 4'
  spec.add_dependency 'astrolabe', '~> 1.3', '>= 1.3.1'
  spec.add_dependency 'rspec', '~> 3.7', '>= 3.7.0'
  spec.add_dependency 'pry-rescue', '~> 1.4', '>= 1.4.4'
  spec.add_dependency 'kommando', '~> 0.1', '>= 0.1.2'
  spec.add_dependency 'rb-readline', '~> 0.5', '>= 0.5.5'

  spec.add_development_dependency 'bundler', '~> 1.15', '>= 1.15.0'
  spec.add_development_dependency 'rake', '~> 12.3', '>= 12.3.0'
end
