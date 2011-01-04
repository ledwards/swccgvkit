Factory.define :cardlist do |f|
  f.title "New Cardlist"
  f.user { Factory(:user) }
end