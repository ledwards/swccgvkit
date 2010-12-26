Factory.sequence :title do |n|
  "Card {n}"
end

Factory.define :card do |f|
  f.title { Factory.next(:title) }
  f.expansion "Premiere"
  f.side "Dark"
  f.card_type "Character"
end