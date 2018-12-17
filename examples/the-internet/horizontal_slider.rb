visit 'the-internet.herokuapp.com/horizontal_slider'

wait 5 do
  has_text? 'Horizontal Slider'
end

slider = find '#content > div > div > input[type="range"]'
slider.type :right, :right, :right

wait 5 do
  (find '#range').text == "4"
end
