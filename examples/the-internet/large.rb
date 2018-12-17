visit 'the-internet.herokuapp.com/large'

wait 5 do
  has_text? 'Large & Deep DOM'
end

wait 5 do
  find '#large-table > tbody > tr.row-17 > td.column-12'
end
