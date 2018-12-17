visit 'the-internet.herokuapp.com/notification_message_rendered'

wait 5 do
  has_text? 'Notification Message'
end

reload

wait 1 do
  has_text? 'Notification Message'
end

click_link 'Click here'

wait 1 do
  has_text? 'Action successful'
end
