require "bundler/setup"
require "superbara"
require "superbara/rspec"

require 'kommando'

RSpec.configure do |config|
  config.fail_fast = true

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def kommando_maker(cmd, opts={})
  k = Kommando.new cmd, {
    output: true,
    timeout: 10
  }.merge(opts)

  k.when :timeout do
    puts "TIMED OUT, killing process"
    Process.kill "INT", Process.pid
    sleep 2
    assert "timed out"
  end

  k
end
