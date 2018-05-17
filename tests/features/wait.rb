run "../common"

visit "/__superbara/wait"

assert do
  has_no_text? "500ms"
end

wait 0.8 do
  has_text? "500ms"
end
