visit 'the-internet.herokuapp.com/dynamic_controls'

wait 5 do
  has_text? 'Dynamic Controls'
end

within '#checkbox-example' do
  wait 5 do
    has_selector? '#checkbox > input[type="checkbox"]'
  end

  click "#checkbox-example > button"

  wait 5 do
    has_no_selector? '#loading'
  end

  wait 5 do
    has_no_selector? '#checkbox > input[type="checkbox"]'
  end

  click '#checkbox-example > button'

  wait 5 do
    has_no_selector? '#loading'
  end

  wait 5 do
    has_selector? 'div > #checkbox'
  end

end

within '#input-example' do
  wait 5 do
    textbox = find 'input[type="text"]'
    textbox[:disabled]
  end

  click "button"

  wait 8 do
    has_selector? "#message"
  end

  textbox = find 'input[type="text"]'

  wait 5 do
    textbox[:disabled] == nil
  end

  textbox.type "asdasd"

  click "button"

  wait 8 do
    has_selector? "#message"
  end

  wait 5 do
    textbox = find 'input[type="text"]'
    textbox[:disabled]
  end

end
