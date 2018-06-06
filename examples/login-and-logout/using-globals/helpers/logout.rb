click_link 'Logout'

wait 3 do
  has_text? 'You logged out'
end
