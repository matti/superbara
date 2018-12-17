visit 'the-internet.herokuapp.com/forgot_password'

wait 5 do
  has_text? 'Forgot Password'
end

email_input = find '#email'
email_input.type 'ngonsdofigjnsdfg@nfdojgndfog.com'

click '#form_submit'

wait 5 do
  has_text? "Your e-mail's been sent!"
end
