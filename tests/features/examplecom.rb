run "../common"

visit "example.com"

wait 5 do
  has_text? "Example Domain"
end

run "../common"
