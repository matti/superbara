visit 'the-internet.herokuapp.com/redirector'

wait 5 do
  has_text? 'Redirection'
end

click_link 'here'

wait 5 do
  has_text? 'Status Codes'
end

click_link '200'

wait 5 do
  has_text? 'This page returned a 200 status code'
end
