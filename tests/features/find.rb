run "../common"

h1 = wait do
  find "h1"
end

assert h1.text do
  h1.text == "Superbara"
end

h1_text = find "h1", text: "Superbara"
assert h1_text.text do
  h1_text.text == "Superbara"
end

another = find "a", text: "Another"
assert another.text do
  another.text == "Another page"
end

