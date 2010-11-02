require 'spec_helper'

describe Card do
  before :each do
    @card = Card.new(:title => "Darth Vader", :card_type => "Character", :expansion => "Premiere", :lore => "darthvaderslore", :gametext => "darthvadersgametext")
    
    @power4 = CardAttribute.create(:name => "Power", :value => "4")
    @armor5 = CardAttribute.create(:name => "Armor", :value => "5")
    @card.card_attributes << @power4
  end
  
  it "is valid with valid attributes" do
    @card.update_attributes(:title => "Darth Vader", :card_type => "Character", :expansion => "Premiere", :lore => "darthvaderslore", :gametext => "darthvadersgametext")
    @card.should be_valid
  end
  
  it "is not valid with no title" do
    @card.update_attributes(:title => nil, :card_type => "Character", :expansion => "Premiere", :lore => "darthvaderslore", :gametext => "darthvadersgametext")
    @card.should_not be_valid
  end
  
  it "is not valid with no card_type" do
    @card.update_attributes(:title => "Darth Vader", :card_type => nil, :expansion => "Premiere", :lore => "darthvaderslore", :gametext => "darthvadersgametext")
    @card.should_not be_valid
  end
  
  it "is not valid with no expansion" do
    @card.update_attributes(:title => "Darth Vader", :card_type => "Character", :expansion => nil, :lore => "darthvaderslore", :gametext => "darthvadersgametext")
    @card.should_not be_valid
  end
  
  it "is unique among title, side, andexpansion" do
  end
  
  describe "#method_missing" do    
    it "allows @card attributes to be directly accessed (ie: Card#power)" do
      @card.power.should == 4
    end
    
    it "allows valid @card attributes that the @card does not have to return nil" do
      @card.armor.should be_nil
    end
  
    it "will trigger method_missing for method names that are not valid attributes" do
      begin
        @card.made_up_attribute
      rescue
        true
      end
    end
  end
  
  describe "#enforce_consistency_of_string_values" do
    it "corrects blank strings for subtype to nil" do
      @card.subtype = ""
      @card.save
      @card.reload.subtype.should be_nil
    end
  end
  
end
