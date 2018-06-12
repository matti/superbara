run "vars"
run "webapp", {}, once: true

visit "#{$test_host}:4567"

wait do
  has_text? "Superbara"
end
