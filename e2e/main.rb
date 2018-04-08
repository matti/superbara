if ENV["CHROME_URL"]
  Capybara.default_driver = :chrome_remote
end

visit "http://www.example.com"

h1 = find "h1"
h1.highlight
