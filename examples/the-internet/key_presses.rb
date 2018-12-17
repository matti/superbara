visit 'the-internet.herokuapp.com/key_presses'

wait 5 do
  has_text? 'Key Presses'
end

find('#content').type 'a'

wait 0.1 do
  has_text? 'You entered: A'
end
