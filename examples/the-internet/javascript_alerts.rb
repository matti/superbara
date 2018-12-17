visit 'the-internet.herokuapp.com/javascript_alerts'

wait 5 do
  has_text? 'JavaScript Alerts'
end

accept_alert do
  click '#content > div > ul > li:nth-child(1) > button'
end

accept_confirm do
  click '#content > div > ul > li:nth-child(2) > button'
end

accept_prompt do
  click '#content > div > ul > li:nth-child(3) > button'
end

wait 0.1 do
  has_text? "You entered:"
end
