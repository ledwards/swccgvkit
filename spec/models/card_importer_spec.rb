require 'spec_helper'

describe CardImporter do
  before :all do
    @file = File.new('spec/fixtures/import_test.cdf', 'r')
    
    valid = @file.readline
    invalid = @file.readline
    virtual = @file.readline
    objective = @file.readline
    vobj = @file.readline
    character = @file.readline
    twoplayer = @file.readline
    r2d2v = @file.readline
    tooonebee = @file.readline
    combo = @file.readline
    ai = @file.readline
    site = @file.readline
    hoth_droid = @file.readline
    
    @lines = {
      "valid" => valid,
      "invalid" => invalid,
      "virtual" => virtual,
      "objective" => objective,
      "vobj" => vobj,
      "character" => character,
      "twoplayer" => twoplayer,
      "r2d2v" => r2d2v,
      "21b" => tooonebee,
      "combo" => combo,
      "ai" => ai,
      "site" => site,
      "hoth_droid" => hoth_droid
    }
    
    @card_importer = CardImporter.new   
  end
  
  describe "#new" do
    it "should initialize a new card" do
      @card_importer.card.should be_new_record
    end
  end
  
  describe "#import" do
    before :all do
      @card = @valid_card = @card_importer.import(@lines["valid"])
      @invalid_card = @card_importer.import(@lines["invalid"])
      @virtual_card = @card_importer.import(@lines["virtual"])
      @objective_card = @card_importer.import(@lines["objective"])
      @vobj_card = @card_importer.import(@lines["vobj"])
      @character_card = @card_importer.import(@lines["character"])
      @twoplayer_card = @card_importer.import(@lines["twoplayer"])
      @r2d2v_card = @card_importer.import(@lines["r2d2v"])
      @too_one_bee_card = @card_importer.import(@lines["21b"])
      @combo_card = @card_importer.import(@lines["combo"])
      @ai = @card_importer.import(@lines["ai"])
      @site_card = @card_importer.import(@lines["site"])
      @hoth_droid_card = @card_importer.import(@lines["hoth_droid"])
    end
    
    it "is a valid card for a valid line" do
      @valid_card.valid?.should be_true
    end
    
    it "is nil for an invalid line" do
      @invalid_card.should be_nil
    end
    
    it "is nil for an AI card" do
      @ai.should be_nil
    end
    
    describe "For an average card (A280 Sharpshooter Rifle)" do
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
    end
    
    describe "when the card is virtual" do
      it "is virtual" do
        @virtual_card.is_virtual?.should be_true
      end
      
      it "has a card image" do
        @virtual_card.has_card_image?.should be_true if online?
      end
      
      it "has a virtual card image" do
        @virtual_card.has_vslip_image?.should be_true if online?
      end
    end
    
    describe "when the card is an Objective" do
      it "is has card_type of Objective" do
        @objective_card.is_flippable?.should be_true
        @objective_card.card_type.should == "Objective"
      end
            
      it "has gametext" do
        @objective_card.gametext.should =~ /While/
      end
      
      it "has a card image url" do
        @objective_card.has_card_image?.should be_true if online?
      end
          
      it "has a card back image" do
        @objective_card.has_card_back_image?.should be_true if online?
      end
    end

    describe "when the card is a virtual card Objective" do
      it "is a card that is both an Objective and virtual" do
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
    
    describe "when the card is a character (Dash Rendar)" do
      it "returns a card that is a Character" do
        @character_card.card_type.should == "Character"
      end
      
      it "has lore" do
        @character_card.lore.should =~ /Corellian/
      end
      
      it "has gametext" do
        @character_card.gametext.should =~ /Outrider/
      end
      
      it "has some characteristics" do
        @character_card.card_characteristics.any?.should be_true
        @character_card.card_characteristics.map(&:name).should =~ ['Pilot', 'Warrior']
      end

      it "has some attributes" do
        @character_card.save!
        @character_card.destiny.should == 3
        @character_card.power.should == 3
        @character_card.ability.should == 3
      end
    end
    
    describe "when the card is from the 2 Player Game" do
      it "has an expansion that should include 'Two Player'" do
        @twoplayer_card.expansion.should =~ /Two Player/
      end
      
      it "has a card image url" do
        @twoplayer_card.has_card_image?.should be_true if online?
      end
    end
    
    describe "when the card is a droid from Premiere/ANH/Virtual Block 1" do
      it "has a card image url" do
        @r2d2v_card.has_card_image?.should be_true if online?
      end
      
      it "has a virtual card image url if it's in Virtual Block 1" do
        @r2d2v_card.is_virtual?.should be_true
        @r2d2v_card.has_card_image?.should be_true if online?
      end
    end
    
    describe "when the card is a droid not from Premiere/ANH/Virtual Block 1" do
      it "has a card image url" do
        @too_one_bee_card.has_card_image?.should be_true if online?
      end
    end
    
    describe "when the card is a combo" do
      it "has an ampersand in the title" do
        @combo_card.title.should =~ /&/
      end
      
      it "has a card image url" do
        @combo_card.has_card_image?.should be_true if online?
      end
    end
    
    describe "when the card is a Used Or Lost Interrupt" do
      it "has gametext" do
        @combo_card.gametext.should be_present
      end
      
      it "has a card_type of 'Interrupt'" do
        @combo_card.card_type.should == "Interrupt"
      end
      
      it "has a subtype of 'Used Or Lost'" do
        @combo_card.subtype.should == "Used Or Lost Interrupt"
      end
      
      it "has a card_type_and_subtype type of 'Used Or Lost Interrupt'" do
        @combo_card.card_type_and_subtype.should == "Used Or Lost Interrupt"
      end
      
      it "had a uniqueness of one dot" do
        @combo_card.uniqueness.should == "•"
      end
      
      it "does not have a characteristic called 'Or Lost'" do
        or_lost = CardCharacteristic.find_by_name("Or Lost")
        @combo_card.card_characteristics.include?(or_lost).should be_false
      end
    end
    
    describe "when the card is a site" do
      it "has gametext" do
        @site_card.gametext.should be_present
      end
    end    
  end
  
  describe "#find_attribute" do
    before :all do
      @card_importer = CardImporter.new
      @card_importer.import(@lines["character"])
    end
    
    it "returns an attribute found in the given line" do
      ca = @card_importer.send(:find_attribute, "Power")
      ca.name.should == "Power"
      ca.value.should == 3
      ca.should be_valid
    end
    
    it "returns nil for an attribute not found in the given line" do
      ca = @card_importer.send(:find_attribute, "Foobar")
      ca.should be_nil
    end
  end
  
  describe "#card_image_url" do
    before :all do
      @card_importer = CardImporter.new
    end
    
    it "returns the expected url for a valid card" do
      @card_importer.import(@lines["valid"])
      @card_importer.send(:card_image_url).should == "http://stuff.ledwards.com/starwars/cards/Endor-Light/large/a280sharpshooterrifle.gif" 
    end
    
    it "returns nil for an invalid card" do
      @card_importer.import(@lines["invalid"])
      @card_importer.send(:card_image_url).should be_nil
    end

    it "returns the expected url for a virtual card" do
      @card_importer.import(@lines["virtual"])
      @card_importer.send(:card_image_url).should == "http://stuff.ledwards.com/starwars/cards/Virtual5-Light/large/letsgoleft.gif" 
    end
    
    it "returns the expected url for an Objective" do
      @card_importer.import(@lines["objective"])
      @card_importer.send(:card_image_url).should == "http://stuff.ledwards.com/starwars/cards/EnhancedJabbasPalace-Light/large/youcaneitherprofitbythis.gif" 
    end

    it "returns the expected url for a virtual Objective" do
      @card_importer.import(@lines["vobj"])
      @card_importer.send(:card_image_url).should == "http://stuff.ledwards.com/starwars/cards/Virtual4-Dark/large/huntdownanddestroythejedi.gif" 
    end

    it "returns the expected url for a Premiere Introductory Two Player Set card" do
      @card = @card_importer.import(@lines["twoplayer"])
      @card_importer.send(:card_image_url).should == "http://stuff.ledwards.com/starwars/cards/PremiereIntroductoryTwoPlayerGame-Light/large/luke.gif"
    end
    
    it "returns the expected url for a droid from Premiere/ANH/Virtual1" do
      @card = @card_importer.import(@lines["r2d2v"])
      @card_importer.send(:card_image_url).should == "http://stuff.ledwards.com/starwars/cards/Virtual1-Light/large/r2d2.gif"
    end
    
    it "returns the expected url for a droid from Hoth/other sets" do
      @card = @card_importer.import(@lines["21b"])
      @card_importer.send(:card_image_url).should == "http://stuff.ledwards.com/starwars/cards/Hoth-Light/large/21btooonebee.gif"
    end
    
    it "returns the expected url for a combo card" do
      @card = @card_importer.import(@lines["combo"])
      @card_importer.send(:card_image_url).should == "http://stuff.ledwards.com/starwars/cards/Coruscant-Light/large/allwingsreportin%26darklighterspin.gif"
    end
    
    it "returns the expected url for a Hoth droid" do
      @card = @card_importer.import(@lines["hoth_droid"])
      @card_importer.send(:card_image_url).should == "http://stuff.ledwards.com/starwars/cards/Hoth-Light/large/r3poarthreepio.gif"
    end
  end
  
  describe "#card_back_image_url" do
    it "returns a string url for the given card" do
      @card_importer.import(@valid_line)
      @card_importer.send(:card_back_image_url).should be_nil 
    end
    
    it "returns the expected url for a virtual objective" do
      @card_importer.import(@lines["vobj"])
      @card_importer.send(:card_back_image_url).should == "http://stuff.ledwards.com/starwars/cards/Virtual4-Dark/large/theirfirehasgoneoutoftheuniverse.gif" 
    end
    
    it "returns the expected url for an objective" do
      @card = @card_importer.import(@lines["objective"])
      @card_importer.send(:card_back_image_url).should == "http://stuff.ledwards.com/starwars/cards/EnhancedJabbasPalace-Light/large/orbedestroyed.gif"
    end
  end
  
  describe "#vslip_image_url" do
    it "returns a string url for the given card" do
      @card_importer.import(@lines["valid"])
      @card_importer.send(:vslip_image_url).should be_nil 
    end
    
    it "returns a string url for the given card" do
      @card_importer.import(@lines["vobj"])
      @card_importer.send(:vslip_image_url).should == "http://stuff.ledwards.com/starwars/vslips/dark/huntdownanddestroythejedi.png"
    end
    
    it "returns a string url for the given card" do
      @card_importer.import(@lines["virtual"])
      @card_importer.send(:vslip_image_url).should == "http://stuff.ledwards.com/starwars/vslips/light/letsgoleft.png"
    end
    
    it "returns a string url for the given card" do
      @card_importer.import(@lines["r2d2v"])
      @card_importer.send(:vslip_image_url).should == "http://stuff.ledwards.com/starwars/vslips/light/r2d2.png"
    end
  end
  
  describe "#vslip_back_image_url" do
    it "returns a string url for the given card" do
      @card_importer.import(@lines["valid"])
      @card_importer.send(:vslip_back_image_url).should be_nil 
    end

    it "returns a string url for the given card" do
      @card_importer.import(@lines["vobj"])
      @card_importer.send(:vslip_back_image_url).should == "http://stuff.ledwards.com/starwars/vslips/dark/theirfirehasgoneoutoftheuniverse.png" 
    end
  end
  
  describe "#import_file" do
    it "calls import for each line of the file" do
      @card_importer.should_receive(:import).exactly(13).times
      @card_importer.import_file('spec/fixtures/import_test.cdf')
    end
    
    it "imports a card for each line of the file" do
      lambda {
        @card_importer.import_file('spec/fixtures/import_test.cdf')
      }.should change {Card.count}.by 11
    end
  end
end