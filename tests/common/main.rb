run "vars"
run "webapp", {}, once: true

loop do
  visit "#{$test_host}:4567"
  sleep 0.1

  break if has_text? "Superbara"
end
