require 'spec_helper'

describe CardAttribute do
  fixtures :card_attributes
  
  it "has a factory" do
    @card_attribute = Factory(:card_attribute)
    @card_attribute.should be_valid
  end
  
  describe "validations" do
    before do
      @card_attribute = card_attributes(:card_attribute)
    end
    
    it "is valid with valid attributes" do
      @card_attribute.should be_valid
    end
    
    it "requires a name" do
      @card_attribute.name = ""
      @card_attribute.should be_invalid
    end
    
    it "requires a value" do
      @card_attribute.value = ""
      @card_attribute.should be_invalid
    end
  end
end
