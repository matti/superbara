run "../common"

visit '/highcharts.html'

wait do
  has_text? "Highcharts"
end

svg = find "svg"
assert svg.text do
  svg.text.include? "500k"
end
