Factory.sequence :title do |n|
  "Card {n}"
end

Factory.define :card do |f|
  f.title { Factory.next(:title) }
  f.expansion "Virtual Block 1"
  f.side "Dark"
  f.card_type "Character"
end