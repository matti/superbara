visit 'the-internet.herokuapp.com/upload'

wait 5 do
  has_text? 'File Uploader'
end

attach_file 'file', __FILE__

click '#file-submit'

wait 5 do
  has_text = 'File Uploaded!'
end
