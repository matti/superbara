require "io/console"
require "colorize"
require "pry_monkey"

require "capybara"
require "capybara/dsl"
require "selenium-webdriver"

require "superbara/version"
require "superbara/dsl"
require "superbara/helpers"
require "superbara/drivers/chrome"
require "superbara/drivers/chrome_headless"

require "rspec"

trap "SIGINT" do
  puts "
control+c pressed, closing the browser..."
  begin
    Timeout::timeout(2) do
      Capybara.current_session.driver.browser.close
    end
  rescue Timeout::Error => e
    puts "Browser failed to close within 2 seconds, exiting anyway.."
  end

  exit 99
end

Capybara.default_driver = :chrome
Capybara.default_max_wait_time = 1

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Superbara::DSL

  config.fail_fast = true

  config.before(:each) do |example|
    $superbara_current_file = example.metadata[:example_group][:file_path]

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
  #
end
