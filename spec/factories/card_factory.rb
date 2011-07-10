Factory.sequence :title do |n|
  "Card #{n}"
end

Factory.define :card do |f|
  f.title { Factory.next(:title) }
  f.expansion "Virtual Block 1"
  f.side "Light"
  f.card_type "Character"
  f.vslip_image_file_name "placeholder.jpg"
end
