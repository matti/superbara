wait 5 do
  visit "example.com"
end

wait 5 do
  has_text? "Example Domain"
end
