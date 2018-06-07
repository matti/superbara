first = run "first_failing"
second = run "second_ok"
third = run "third_failing"

assert "first" do
  first == nil
end

assert "second" do
  second == "second"
end

assert "third" do
  third == nil
end
