visit 'the-internet.herokuapp.com/login'

wait 5 do
  has_text? 'Login Page'
end

find('#username').type 'tomsmith'
find('#password').type 'SuperSecretPassword!'

click 'button'

wait 5 do
  has_text? 'Welcome to the Secure Area.'
end
sleep 1

click 'a.button'
