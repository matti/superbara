run "vars"
run "webapp", {}, once: true

visit "#{$test_host}:4567"
