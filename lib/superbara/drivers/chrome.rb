Capybara.register_driver :chrome do
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.add_argument 'window-size=1680,1024'
  options.add_argument 'disable-infobars'

  Capybara::Selenium::Driver.new(nil,
    browser: :chrome,
    options: options
  )
end
