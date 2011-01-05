FixtureBuilder.configure do |fbuilder|
  # rebuild fixtures automatically when these files change:
  fbuilder.files_to_check += Dir["spec/factories/*.rb", "spec/support/fixture_builder.rb"]

  # now declare objects
  fbuilder.factory do |f|
    f.name("user", Factory(:user))

    f.name("admin", Factory(:role, :name => "admin"))
    f.name("admin", Factory(:user))
    User.last.roles << Role.last
    
    f.name("card", Factory(:card))
    f.name("other_card", Factory(:card))
    
    f.name("card_attribute", Factory(:card_attribute))
    f.name("card_characteristic", Factory(:card_characteristic))
    
    f.name("cardlist", Factory(:cardlist))
    f.name("cardlist_item", Factory(:cardlist_item))
  end
end