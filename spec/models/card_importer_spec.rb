require 'spec_helper'

describe CardImporter do
  describe "#new" do
    it "should initialize a new card" do
      card_importer = CardImporter.new
      card_importer.card.should_not be_nil
    end
  end
  
  describe "#import" do
    before do
      @card_importer = CardImporter.new
      @file = File.new('spec/fixtures/import_test.cdf', 'r')
      line = @file.gets
      @card = @card_importer.import(line)
    end
    
    after do
      @file.rewind
    end
    
    it "is a valid card" do
      @card.valid?.should be_true
    end
    
    it "is nil for an invalid line" do
      line = @file.gets
      line.should =~ /invalid line/
      invalid_card = @card_importer.import(line)
      invalid_card.should be_nil
    end
    
    it "has a title" do
      @card.title.should == "A280 Sharpshooter Rifle"
    end
    
    it "has a expansion" do
      @card.expansion.should == "Endor"
    end
    
    it "has a card type" do
      @card.card_type.should == "Weapon"
    end
    
    it "has a uniqueness" do
      @card.uniqueness.should == "••"
    end
    
    it "has a side" do
      @card.side.should == "Light"
    end
    
    it "has a rarity" do
      @card.rarity.should == "R"
    end
    
    it "has a subtype" do
      @card.subtype.should == "Character Weapon"
    end
    
    it "has a destiny" do
      @card.save
      @card.destiny.should == 3
    end
    
    it "has a card image url" do
      @card.has_card_image?.should be_true
    end

    describe "When the card is a virtual card Objective" do
      before do
        2.times { @line = @file.gets }
        @card_importer = CardImporter.new
        @objective = @card_importer.import(@line)        
      end
      
      it "returns a card that is both an Objective and virtual" do
        @objective.is_virtual?.should be_true
        @objective.is_flippable?.should be_true
        @objective.card_type.should == "Objective"
      end
      
      it "has gametext" do
        @objective.gametext.should =~ /While/
      end
      
      it "has a card image url" do
        @objective.save!
        @objective.has_card_image?.should be_true
      end
      
      it "has a virtual slip image" do
        @objective.save!
        @objective.has_vslip_image?.should be_true
      end
    
      it "has a card back image" do
        @objective.save!
        @objective.has_card_back_image?.should be_true
      end
    
      it "has a virtual slip back image" do
        @objective.save!
        @objective.has_vslip_back_image?.should be_true
      end
    end
    
    describe "When the card is a character (Dash Rendar)" do
      before do
        3.times { @line = @file.gets }
        @card_importer = CardImporter.new
        @character = @card_importer.import(@line)        
      end
      
      it "returns a card that is a Character" do
        @character.card_type.should == "Character"
      end
      
      it "has some characteristics" do
        @character.card_characteristics.any?.should be_true
        @character.card_characteristics.map(&:name).should =~ ['Pilot', 'Warrior']
      end

      it "has some attributes" do
        @character.save
        @character.destiny.should == 3
        @character.power.should == 3
        @character.ability.should == 3
      end
      
      it "has lore" do
        @character.lore.should =~ /Corellian/
      end
      
      it "has gametext" do
        @character.gametext.should =~ /Outrider/
      end
      
      it "has a card image url" do
        @character.save!
        @character.has_card_image?.should be_true
      end
      
    end
  end
  
  describe "#find_attribute" do
    before do
      @card_importer = CardImporter.new
      @file = File.new('spec/fixtures/import_test.cdf', 'r')
      4.times { @line = @file.gets }
    end
    
    it "returns an attribute found in the given line" do
      ca = @card_importer.find_attribute("Power", @line)
      ca.name.should == "Power"
      ca.value.should == 3
      ca.valid?.should be_true
    end
    
    it "returns nil for an attribute not found in the given line" do
      ca = @card_importer.find_attribute("Foobar", @line)
      ca.should be_nil
    end
    
  end
  
  describe "#import_file" do
    it "creates a log file in development or test mode" do
    end
    
    it "does not create a log file in production mode" do
    end
    
  end
end