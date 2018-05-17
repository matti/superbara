run "../common"

visit "/__superbara/prompt"

message = accept_prompt with: 'Linda Liukas' do
  click_link 'Author Quiz!'
end

assert message do
  message == 'Who is the author of Hello Ruby?'
end
