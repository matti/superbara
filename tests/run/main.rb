run "has_instance_variables", first: "hello", second: "world"

assert "first" do
  @first.nil?
end

assert "second" do
  @first.nil?
end

run "has_no_instance_variables"

value = run "value"

assert "value" do
  value == "hello"
end


values = []
3.times do
  values << (run "once", {}, once: true)
end

assert "once" do
  values == ["once", nil, nil]
end
