require 'spec_helper'

describe CardImporter do
  before :all do
    @file = File.new('spec/fixtures/import_test.cdf', 'r')
    @valid_line = @file.readline
    @invalid_line = @file.readline
    @vobj_line = @file.readline
    @character_line = @file.readline
    @jp_line = @file.readline
    @card_importer = CardImporter.new   
  end
  
  describe "#new" do
    it "should initialize a new card" do
      @card_importer.card.should be_new_record
    end
  end
  
  describe "#import" do
    before :all do
      @card_importer = CardImporter.new
      @card = @valid_card = @card_importer.import(@valid_line)
      @invalid_card = @card_importer.import(@invalid_line)
      @vobj_card = @card_importer.import(@vobj_line)
      @character_card = @card_importer.import(@character_line)
      @jp_card = @card_importer.import(@jp_line)
    end
    
    it "is a valid card for a valid line" do
      @valid_card.valid?.should be_true
    end
    
    it "is nil for an invalid line" do
      @invalid_card.should be_nil
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
    
    it "has a card image" do
      @card.has_card_image?.should be_true if online?
    end

    context "when the card is a virtual card Objective" do      
      it "returns a card that is both an Objective and virtual" do
        @vobj_card.is_virtual?.should be_true
        @vobj_card.is_flippable?.should be_true
        @vobj_card.card_type.should == "Objective"
      end
      
      it "has gametext" do
        @vobj_card.gametext.should =~ /While/
      end
      
      it "has a card image url" do
        @vobj_card.has_card_image?.should be_true if online?
      end
      
      it "has a virtual slip image" do
        @vobj_card.has_vslip_image?.should be_true if online?
      end
    
      it "has a card back image" do
        @vobj_card.has_card_back_image?.should be_true if online?
      end
    
      it "has a virtual slip back image" do
        @vobj_card.has_vslip_back_image?.should be_true if online?
      end
    end
    
    describe "When the card is a character (Dash Rendar)" do
      it "returns a card that is a Character" do
        @character_card.card_type.should == "Character"
      end
      
      it "has some characteristics" do
        @character_card.card_characteristics.any?.should be_true
        @character_card.card_characteristics.map(&:name).should =~ ['Pilot', 'Warrior']
      end

      it "has some attributes" do
        @character_card.save
        @character_card.destiny.should == 3
        @character_card.power.should == 3
        @character_card.ability.should == 3
      end
      
      it "has lore" do
        @character_card.lore.should =~ /Corellian/
      end
      
      it "has gametext" do
        @character_card.gametext.should =~ /Outrider/
      end
      
      it "has a card image url" do
        @character_card.has_card_image?.should be_true if online?
      end
    end
    
    describe "When the card is in Jabba's Palace" do      
      it "has the expansion Jabba's Palace" do
        @jp_card.expansion.should == "Jabba's Palace"
      end
      
      it "has a valid card image" do
        @jp_card.has_card_image?.should be_true if online?
      end
      
    end
  end
  
  describe "#find_attribute" do
    before :all do
      @card_importer = CardImporter.new
      @line = @character_line
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
  
  describe "#card_image_url" do    
    it "returns a string url for the given card" do
      @card_importer.import(@valid_line)
      @card_importer.send(:card_image_url).should == "http://swccgpc.com/gallery/var/albums/Endor/Light-Side/a280sharpshooterrifle.gif" 
    
      @card_importer.import(@vobj_line)
      @card_importer.send(:card_image_url).should == "http://swccgpc.com/gallery/var/albums/Virtual-Block-4/Dark-Side/huntdownanddestroythejedi.gif" 
    
      @card_importer.import(@character_line)
      @card_importer.send(:card_image_url).should == "http://swccgpc.com/gallery/var/albums/Reflections/Reflections-II/Light-Side/dashrendar.gif" 
    
      @card = @card_importer.import(@jp_line)
      @card_importer.send(:card_image_url).should == "http://swccgpc.com/gallery/var/albums/Jabbas-Palace/Light-Side/attark.gif" 
    end
  end
  
  describe "#card_back_image_url" do
    it "returns a string url for the given card" do
      @card_importer.import(@valid_line)
      @card_importer.send(:card_back_image_url).should be_nil 

      @card_importer.import(@vobj_line)
      @card_importer.send(:card_back_image_url).should == "http://swccgpc.com/gallery/var/albums/Virtual-Block-4/Dark-Side/theirfirehasgoneoutoftheuniverse.gif" 

      @card_importer.import(@character_line)
      @card_importer.send(:card_back_image_url).should be_nil 

      @card = @card_importer.import(@jp_line)
      @card_importer.send(:card_back_image_url).should be_nil 
    end
  end
  
  describe "#vslip_image_url" do
    it "returns a string url for the given card" do
      @card_importer.import(@valid_line)
      @card_importer.send(:vslip_image_url).should be_nil 

      @card_importer.import(@vobj_line)
      @card_importer.send(:vslip_image_url).should == "http://stuff.ledwards.com/starwars/dark/huntdownanddestroythejedi.png" 

      @card_importer.import(@character_line)
      @card_importer.send(:vslip_image_url).should be_nil 

      @card = @card_importer.import(@jp_line)
      @card_importer.send(:vslip_image_url).should be_nil 
    end
  end
  
  describe "#vslip_back_image_url" do
    it "returns a string url for the given card" do
      @card_importer.import(@valid_line)
      @card_importer.send(:vslip_back_image_url).should be_nil 

      @card_importer.import(@vobj_line)
      @card_importer.send(:vslip_back_image_url).should == "http://stuff.ledwards.com/starwars/dark/theirfirehasgoneoutoftheuniverse.png" 

      @card_importer.import(@character_line)
      @card_importer.send(:vslip_back_image_url).should be_nil 

      @card = @card_importer.import(@jp_line)
      @card_importer.send(:vslip_back_image_url).should be_nil 
    end
  end
  
  describe "#import_file" do
    it "calls import for each line of the file" do
      @card_importer.should_receive(:import).exactly(5).times
      @card_importer.import_file('spec/fixtures/import_test.cdf')
    end
    
    it "imports a card for each line of the file" do
      @card_importer.import_file('spec/fixtures/import_test.cdf')
      Card.count.should == 4
    end
    
    it "logs errors on the model" do
      Rails.logger.should_receive(:error).at_least(1).times
      @card_importer.import_file('spec/fixtures/import_test.cdf')
    end
  end
end