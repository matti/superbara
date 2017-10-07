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

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `if [ -d '.git' ]; then git ls-files -z; fi`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "colorize", "0.8.1"
  spec.add_dependency "pry-byebug", "3.4.2"
  spec.add_dependency "binding_of_caller", "0.7.2"
  spec.add_dependency "capybara", "2.15.1"
  spec.add_dependency "selenium-webdriver", "3.5.1"
  spec.add_dependency "rspec", "3.6.0"
  spec.add_dependency "chromedriver-helper", "1.1.0"

  spec.add_development_dependency "rerun", "0.11.0"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
end
