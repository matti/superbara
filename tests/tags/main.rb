simple = run "simple"
block = run "block"
notags = run "notags"
fails = run "fails"

assert "simple" do
  simple == true
end

assert "block" do
  block == true
end

assert "notags" do
  notags == true
end

assert "fails" do
  fails == false
end
