simple = run "simple"
block = run "block"
notags = run "notags"
fails = run "fails"

assert "simple" do
  simple == "simple"
end

assert "block" do
  block == "block"
end

assert "notags" do
  notags == "notags"
end
