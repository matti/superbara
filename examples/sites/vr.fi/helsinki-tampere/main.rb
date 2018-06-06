visit 'vr.fi'

languages = wait do
  find("div.langbox")
end

english = languages.find("a", text: "EN")
english.click

wait 3 do
  has_text? "Search timetables"
end

type :tab, "hels", :down, :tab, :tab
type "tamp", :down, :enter

type :enter

wait 10 do
  has_text? "Outbound journey:  Helsinki → Tampere"
end
