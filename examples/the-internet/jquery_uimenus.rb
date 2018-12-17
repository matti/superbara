visit 'the-internet.herokuapp.com/jqueryui/menu'

wait 5 do
  has_text? 'JQueryUI - Menu'
end

find('a', text: 'Enabled').hover
sleep 0.5
find('a', text: 'Downloads').hover
sleep 0.5

wait 0.1 do
  has_text? "CSV"
end
