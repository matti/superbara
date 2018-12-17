visit 'the-internet.herokuapp.com/geolocation'

wait 5 do
  has_text? 'Geolocation'
end

click '#content > div > button'

page.execute_script """
  navigator.geolocation.getCurrentPosition = function(success) { console.log(success) }
"""

puts "TODO: api deprecated?"

# wait 5 do
#   has_text? 'Latitude'
# end
