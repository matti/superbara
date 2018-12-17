visit 'the-internet.herokuapp.com/tinymce'

wait 5 do
  has_text? 'An iFrame'
end

iframe = find '#mce_0_ifr'
within_frame iframe do
  input = find '#tinymce'
  input.type 'asdasdasdasd'
end
