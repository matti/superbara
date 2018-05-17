require "superbara"
require "superbara/dsl"
require "rspec"

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Superbara::DSL

  config.fail_fast = true

  config.before(:each) do |example|
    #TODO
    #$superbara_current_file = example.metadata[:example_group][:file_path]

    puts ""
    class_path = example.example_group_instance.class.to_s.split("::")
    class_path.shift
    class_path.shift
    print class_path.shift
    for c in class_path do
      print "/#{c}"
    end
    puts " #{example.description} - #{example.location}"
    puts "-"*IO.console.winsize.last
  end

  config.after(:each) do |example|
    if example.exception
      puts ("="*80).colorize(:yellow)
      puts example.exception.message.colorize(:red)
      puts ("="*80).colorize(:yellow)
      debug(exception_occurred: true)
    end
  end
end
