visit 'the-internet.herokuapp.com/broken_images'

wait 5 do
  has_text? 'Broken Images'
end

broken_img = (all 'div.example img').first
visit broken_img[:src]
wait 5 do
  has_text? 'Not Found'
end

back

wait 5 do
  has_text? 'Broken Images'
end

normal_img = (all 'div.example img').last
visit normal_img[:src]
wait 5 do
  has_no_text? 'Not Found'
end
