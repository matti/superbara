Capybara.register_driver :chrome_remote do
  Capybara::Selenium::Driver.new(nil,
    browser: :remote,
    desired_capabilities: :chrome,
    url: "http://#{ENV['CHROME_HOST'] || 'chrome'}:#{ENV['CHROME_PORT'] || '4444'}/wd/hub"
  )
end
