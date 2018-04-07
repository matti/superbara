require "io/console"
require "colorize"

require "capybara"
require "capybara/dsl"
require "selenium-webdriver"

require_relative "capybara_monkey"
require_relative "pry_monkey"

module Superbara
  def self.puts(str)
    return unless ENV["SUPERBARA_DEBUG"]
    Kernel.puts "Superbara #{caller[0][/`.*'/][1..-2]}: #{str}"
  end
end

require_relative "superbara/version"
require_relative "superbara/helpers"

require_relative "superbara/chrome"

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

Superbara::Chrome.register_drivers

require "chromedriver/helper"
Chromedriver.set_version "2.37"

Capybara.default_driver = :chrome
Capybara.default_max_wait_time = 1

