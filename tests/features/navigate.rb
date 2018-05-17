run "../common"

click_link "Another page"

assert current_url do
  current_url.end_with? "/another.html"
end

back

assert current_url do
  current_url.end_with? "/"
end

forward

assert current_url do
  current_url.end_with? "/another.html"
end

back

visit "/__superbara/wait"

wait 0.8 do
  has_text? "500ms"
end

reload

assert text do
  ! text.match? "500ms"
end

wait 0.8 do
  has_text? "500ms"
end
