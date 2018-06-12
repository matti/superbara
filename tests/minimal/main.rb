run "../common", {}, once: true do
  puts "common already loaded"
end

value = run "minimal"
assert value do
  value == "hello from minimal.rb"
end
