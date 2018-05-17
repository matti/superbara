require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec, :superbara]

task :superbara do
  require 'kommando'

  k = Kommando.new "bin/tests", {
    output: true
  }

  k.run

  raise "not clean" unless k.code == 0
end
