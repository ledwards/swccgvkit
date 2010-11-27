require 'spec_helper'

describe CardCharacteristic do
  fixtures :card_characteristics
  
  it "has a factory" do
    Factory(:card_characteristic).should be
  end
  
  describe "validations" do
    before do
      @card_characteristic = card_characteristics(:card_characteristic)
    end
    
    it "should be valid for valid attributes" do
      @card_characteristic.should be_valid
    end
    
    it "should be invalid when missing a name" do
      @card_characteristic.name = ""
      @card_characteristic.should be_invalid
    end
  end
end
