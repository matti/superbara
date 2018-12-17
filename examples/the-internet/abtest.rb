visit 'the-internet.herokuapp.com/abtest'

wait 5 do
  has_text? 'A/B Test'
end

print 'got: '
if has_text? 'A/B Test Control'
  puts 'control'
elsif has_text? 'A/B Test Variation 1'
  puts 'var 1'
end

