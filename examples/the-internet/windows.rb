visit 'the-internet.herokuapp.com/windows'

wait 5 do
  has_text? 'Opening a new window'
end

click_link 'Click Here'
switch_to_window windows.last

wait 5 do
  has_text? 'New Window'
end

switch_to_window windows.first

wait 5 do
  has_text? 'Opening a new window'
end
