if ENV["CHROME_HOST"]
  Capybara.default_driver = :chrome_remote
end

visit "http://www.example.com"

h1 = find "h1"
h1.highlight
