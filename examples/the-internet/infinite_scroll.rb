visit 'the-internet.herokuapp.com/infinite_scroll'

wait 5 do
  has_text? 'Infinite Scroll'
end

10.times do
  scroll 20
  sleep 0.1
end
