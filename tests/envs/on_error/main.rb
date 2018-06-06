first = run "first_failing"
second = run "second_ok"
third = run "third_failing"

assert do
  first == false
end

assert do
  second == true
end

assert do
  third == false
end
