visit "admin:admin@the-internet.herokuapp.com/basic_auth"

wait 5 do
  has_text? "Congratulations"
end
