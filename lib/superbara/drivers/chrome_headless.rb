Capybara.register_driver :chrome_headless do
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.add_argument 'headless'
  options.add_argument 'disable-gpu'
  options.add_argument 'window-size=1680,1024'

  Capybara::Selenium::Driver.new(nil,
    browser: :chrome,
    options: options
  )
end
