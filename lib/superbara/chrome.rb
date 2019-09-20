module Superbara; module Chrome
  @@page_load_strategy = "normal"

  def self.page_load_strategy=(strategy)
    raise "unknown strategy: #{strategy}" unless ["none", "normal"].include? strategy
    @@page_load_strategy = strategy

    self.register_drivers
  end

  def self.register_drivers
    options = ::Selenium::WebDriver::Chrome::Options.new
    options.add_argument 'window-size=1300,800'
    options.add_argument 'disable-infobars'

    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      pageLoadStrategy: @@page_load_strategy,
    )

    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 10

    Capybara.register_driver :chrome do
      Capybara::Selenium::Driver.new(nil,
        driver_path: Superbara.chromedriver_path,
        browser: :chrome,
        http_client: client,
        options: options,
        desired_capabilities: capabilities
      )
    end

    Capybara.register_driver :chrome_remote do
      chrome_url = ENV['CHROME_URL']

      Capybara::Selenium::Driver.new(nil,
        browser: :remote,
        http_client: client,
        desired_capabilities: capabilities,
        options: options,
        url: chrome_url
      )
    end

    Capybara.register_driver :chrome_headless do
      options.add_argument 'disable-gpu'

      Capybara::Selenium::Driver.new(nil,
        driver_path: Superbara.chromedriver_path,
        browser: :chrome,
        http_client: client,
        desired_capabilities: capabilities,
        options: options
      )
    end
  end
end; end
