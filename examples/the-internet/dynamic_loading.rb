visit "the-internet.herokuapp.com/dynamic_loading"

wait 5 do
  has_text? "Dynamically Loaded Page Elements"
end

click_link "Example 1"

wait 5 do
  has_text? "Example 1"
end

click "#start > button"

wait 5 do
  has_no_selector? "#loading"
end

wait 5 do
  has_text? "Hello World"
end

back

wait 5 do
  has_text? "Dynamically Loaded Page Elements"
end

click_link "Example 2"

wait 5 do
  has_text? "Example 2"
end

click "#start > button"

wait 5 do
  has_no_selector? "#loading"
end

wait 5 do
  has_text? "Hello World"
end
