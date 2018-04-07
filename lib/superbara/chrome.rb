module Superbara; module Chrome
  @@page_load_strategy = "normal"

  def self.page_load_strategy=(strategy)
    raise "unknown strategy: #{strategy}" unless ["none", "normal"].include? strategy
    @@page_load_strategy = strategy

    self.register_drivers
  end

  def self.register_drivers
    options = ::Selenium::WebDriver::Chrome::Options.new
    options.add_argument 'window-size=1680,1024'
    options.add_argument 'disable-infobars'

    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      pageLoadStrategy: @@page_load_strategy
    )

    Capybara.register_driver :chrome do
      Capybara::Selenium::Driver.new(nil,
        browser: :chrome,
        options: options,
        desired_capabilities: capabilities
      )
    end

    Capybara.register_driver :chrome_remote do
      Capybara::Selenium::Driver.new(nil,
        browser: :remote,
        desired_capabilities: capabilities,
        url: "http://#{ENV['CHROME_HOST'] || 'chrome'}:#{ENV['CHROME_PORT'] || '4444'}/wd/hub"
      )
    end

    Capybara.register_driver :chrome_headless do
      options.add_argument 'disable-gpu'

      Capybara::Selenium::Driver.new(nil,
        browser: :chrome,
        desired_capabilities: capabilities,
        options: options
      )
    end

    Superbara.puts "registered drivers"
    Superbara.puts capabilities.inspect
  end
end; end
