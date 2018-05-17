visit "/__superbara/wait"

fail if has_text? "500ms"

wait 0.8 do
  has_text? "500ms"
end
