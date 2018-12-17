visit 'the-internet.herokuapp.com/slow'

wait 31 do
  has_text? 'Slow Resources'
end
