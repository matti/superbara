visit "the-internet.herokuapp.com/dynamic_content"

wait 5 do
  has_text? "Dynamic Content"
end

click_on "click here"

wait 5 do
  has_text? "Dynamic Content"
end

old_text = find("#content > div:nth-child(7) > div.large-10.columns").text

reload

wait 5 do
  has_text? "Dynamic Content"
end

new_text = find("#content > div:nth-child(7) > div.large-10.columns").text

wait 5 do
  old_text != new_text
end
