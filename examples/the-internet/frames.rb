visit 'the-internet.herokuapp.com/frames'

wait 5 do
  has_text? 'Frames'
end

click_link 'Nested Frames'

wait 5 do
  has_selector? 'html > frameset'
end

top_frame = find 'html > frameset > frame:nth-child(1)'
switch_to_frame top_frame

left_frame = find 'html > frameset > frame:nth-child(1)'
switch_to_frame left_frame

wait 10 do
  has_text? 'LEFT'
end

back

wait 5 do
  has_text? 'Frames'
end

click_link 'iFrame'

wait 10 do
  has_text? 'An iFrame containing the TinyMCE WYSIWYG Editor'
end

iframe = find '#mce_0_ifr'
within_frame iframe do
   text = find('#tinymce').text
   wait 5 do
    text == 'Your content goes here.'
   end
end
