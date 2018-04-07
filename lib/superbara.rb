require "io/console"
require "colorize"

require "capybara"
require "capybara/dsl"
require "selenium-webdriver"

require_relative "capybara_monkey"
require_relative "pry_monkey"

require_relative "superbara/version"
require_relative "superbara/helpers"

require_relative "superbara/drivers/chrome"
require_relative "superbara/drivers/chrome_headless"
require_relative "superbara/drivers/chrome_remote"

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

require "chromedriver/helper"
Chromedriver.set_version "2.37"

Capybara.default_driver = :chrome
Capybara.default_max_wait_time = 1

