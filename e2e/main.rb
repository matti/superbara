run "init", once: true
run "vars"

visit "#{$test_host}:4567"
wait "3" do
  has_text? "Superbara"
end

run "wait"
run "prompt"
run "type"

run "example", once: true do
  visit "example.com"
end

find "h1"
