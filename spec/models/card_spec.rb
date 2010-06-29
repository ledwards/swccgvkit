require 'spec_helper'

describe Card do
  it "is valid with valid attributes" do
    card = Card.new(:title => "Darth Vader", :card_type => "Character", :expansion => "Premiere", :lore => "darthvaderslore", :gametext => "darthvadersgametext")
    card.should be_valid
  end
  
  it "is not valid with no title" do
    card = Card.new(:title => nil, :card_type => "Character", :expansion => "Premiere", :lore => "darthvaderslore", :gametext => "darthvadersgametext")
    card.should_not be_valid
  end
  
  it "is not valid with no card_type" do
    card = Card.new(:title => "Darth Vader", :card_type => nil, :expansion => "Premiere", :lore => "darthvaderslore", :gametext => "darthvadersgametext")
    card.should_not be_valid
  end
  
  it "is not valid with no expansion" do
    card = Card.new(:title => "Darth Vader", :card_type => "Character", :expansion => nil, :lore => "darthvaderslore", :gametext => "darthvadersgametext")
    card.should_not be_valid
  end
  
  it "is not valid with mismatched passwords" do
    user = User.new(:email => "darthvader@empire.com", :password => "noooooooooooooooo", :password_confirmation => "iwantthemalive")
    user.should_not be_valid
  end
end
