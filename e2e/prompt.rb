visit "/__superbara/prompt"

message = accept_prompt with: 'Linda Liukas' do
  click_link 'Author Quiz!'
end

fail unless message == 'Who is the author of Hello Ruby?'
