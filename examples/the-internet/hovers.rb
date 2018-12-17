visit 'the-internet.herokuapp.com/hovers'

wait 5 do
  has_text? 'Hovers'
end

find('#content > div > div:nth-child(3) > img').hover

wait 0.1 do
  has_text? 'user1'
end

find('#content > div > div:nth-child(4) > img').hover

wait 0.1 do
  has_text? 'user2'
end

find('#content > div > div:nth-child(5) > img').hover

wait 0.1 do
  has_text? 'user3'
end

find("h3", text: "Hovers").hover

