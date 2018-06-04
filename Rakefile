require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'kommando'

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec, :cli, :examples]

task :cli do
  k = Kommando.new "bin/tests", {
    output: true
  }

  k.run

  raise "not clean" unless k.code == 0
end

task :examples do
  mains = Dir.glob("examples/**/main.rb")

  for main in mains do
    k = Kommando.new "exe/superbara run #{main}", {
      output: true
    }

    k.run

    raise "not clean" unless k.code == 0
  end
end
