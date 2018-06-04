focus once: true

visit 'pharos.sh'

wait 3 do
  has_text? 'The simple, solid, certified Kubernetes'
end

click "a", text: "Pricing"

3.times do
  buttons = all "button"
  buttons.first.click
end
