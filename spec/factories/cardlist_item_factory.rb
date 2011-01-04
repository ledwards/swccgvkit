Factory.define :cardlist_item do |f|
  f.card { Factory(:card) }
  f.quantity 1
  f.cardlist { Factory(:cardlist) }
end