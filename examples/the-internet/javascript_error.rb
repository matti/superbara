visit 'the-internet.herokuapp.com/javascript_error'

wait 5 do
  has_text? 'This page has a JavaScript error in the onload event.'
end

