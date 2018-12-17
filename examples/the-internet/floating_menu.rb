visit 'the-internet.herokuapp.com/floating_menu'

wait 5 do
  has_text? 'Floating Menu'
end

menu = find '#menu'

within menu do
  click_link 'Home'
end

wait 5 do
  current_url.include? 'home'
end
