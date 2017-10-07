Capybara.register_driver :chrome_headless do
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.add_argument 'headless'
  options.add_argument 'disable-gpu'

  Capybara::Selenium::Driver.new(nil,
    browser: :chrome,
    options: options
  )
end
