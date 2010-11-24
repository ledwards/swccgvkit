require 'spec_helper'

describe CardImporter do
  before :all do
    @file = File.new('spec/fixtures/import_test.cdf', 'r')
    @valid_line = @file.readline
    @invalid_line = @file.readline
    @vobj_line = @file.readline
    @character_line = @file.readline
    @jp_line = @file.readline
    @theed_line = @file.readline
    @virtualblock_line = @file.readline
    @jedi_pack_line = @file.readline
    @two_player_line = @file.readline
    @two_player_esb_line = @file.readline
    @coruscant_obj_line = @file.readline
    @tatooine_line = @file.readline
    @ejp_obj_line = @file.readline
    @ecc_obj_line = @file.readline
    @sped_line = @file.readline
    @otsd_line = @file.readline
    @epp_line = @file.readline
    @rebel_leader_line = @file.readline
    @third_anthology_line = @file.readline
    @jpotsd_line = @file.readline
    @bothawui_operative_line = @file.readline
    @recoil_in_fear_line = @file.readline
    @r2d2v_line = @file.readline
    @dosv_line = @file.readline
    @card_importer = CardImporter.new   
  end
  
  describe "#new" do
    it "should initialize a new card" do
      @card_importer.card.should be_new_record
    end
  end
  
  describe "#import" do
    before :all do
      @card = @valid_card = @card_importer.import(@valid_line)
      @invalid_card = @card_importer.import(@invalid_line)
      @vobj_card = @card_importer.import(@vobj_line)
      @character_card = @card_importer.import(@character_line)
      @jp_card = @card_importer.import(@jp_line)
      @otsd_card = @card_importer.import(@otsd_line)
      @bothawui_operative_card = @card_importer.import(@bothawui_operative_line)
      @recoil_in_fear_card = @card_importer.import(@recoil_in_fear_line)
    end
    
    before :each do
      @card_importer = CardImporter.new
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

    describe "when the card is a virtual card Objective" do
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
    
    describe "When the card is in OTSD" do
      it "has the expansion Official Tournament Sealed Deck" do
        @otsd_card.expansion == "Official Tournament Sealed Deck"
      end
      
      it "has a valid card image" do
        @otsd_card.has_card_image?.should be_true if online?
      end
    end
    
    describe "When the card is a Bothawui Operative" do
      it "is valid" do
        @bothawui_operative_card.should be_valid
      end
      
      it "has a valid card image" do
        @bothawui_operative_card.has_card_image?.should be_true if online?
      end
    end
    
    describe "When the card is Recoil in Fear" do
      it "is valid" do
        @recoil_in_fear_card.should be_valid
      end
      
      it "has a valid card image" do
        @recoil_in_fear_card.has_card_image?.should be_true if online?
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
    before :each do
      @card_importer = CardImporter.new
    end
    
    it "returns a string url for the given card" do
      @card_importer.import(@valid_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Endor/Light-Side/a280sharpshooterrifle.gif" 
    end
    
    it "returns a string url for the given card" do
      @card_importer.import(@vobj_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Virtual-Block-4/Dark-Side/huntdownanddestroythejedi.gif" 
    end
    
    it "returns a string url for the given card" do
      @card_importer.import(@character_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Reflections/Reflections-II/Light-Side/dashrendar.gif" 
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@jp_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Jabbas-Palace/Light-Side/attark.gif" 
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@theed_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/cards/THEED/LS/wehaveaplan.jpg"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@virtualblock_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Virtual-Block-5/Light-Side/letsgoleft.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@jedi_pack_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Premium/Dark-Side/tarkin.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@two_player_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Premium/Dark-Side/vader.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@two_player_esb_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Premium/Dark-Side/veers.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@coruscant_obj_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Coruscant/Light-Side/pleadmycasetothesenate.jpg"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@tatooine_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Tatooine/Light-Side/anakinspodracer.jpg"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@ejp_obj_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Premium/Light-Side/youcaneitherprofitbythis.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@ecc_obj_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Premium/Light-Side/quietminingcolony.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@sped_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Special-Edition/Dark-Side/brangussglee.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@otsd_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Premium/Light-Side/arleilschous.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@epp_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Premium/Light-Side/lukewithlightsaber.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@rebel_leader_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Premium/Light-Side/redleaderinred1.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@third_anthology_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/cards/3RD_ANTHOLOGY/setyourcourseforalderaan.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@jpotsd_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Premium/Dark-Side/mightyjabba.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@bothawui_operative_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Special-Edition/Light-Side/bothawuioperative.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@recoil_in_fear_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Dagobah/Light-Side/recoilinfear.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@r2d2v_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/gallery/var/albums/Virtual-Block-1/Light-Side/r2d2.gif"
    end

    it "returns a string url for the given card" do
      @card = @card_importer.import(@dosv_line)
      @card_importer.send(:card_image_url).should == "http://starwarsccg.org/cards/v6/ls/daughterofskywalker.JPG"
    end
    
  end
  
  describe "#card_back_image_url" do
    it "returns a string url for the given card" do
      @card_importer.import(@valid_line)
      @card_importer.send(:card_back_image_url).should be_nil 
    end
    
    it "returns a string url for the given card" do
      @card_importer.import(@vobj_line)
      @card_importer.send(:card_back_image_url).should == "http://starwarsccg.org/gallery/var/albums/Virtual-Block-4/Dark-Side/theirfirehasgoneoutoftheuniverse.gif" 
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@theed_line)
      @card_importer.send(:card_back_image_url).should == "http://starwarsccg.org/cards/THEED/LS/theywillbelostandconfused.jpg"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@coruscant_obj_line)
      @card_importer.send(:card_back_image_url).should == "http://starwarsccg.org/gallery/var/albums/Coruscant/Light-Side/sanityandcompassion.jpg"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@ejp_obj_line)
      @card_importer.send(:card_back_image_url).should == "http://starwarsccg.org/gallery/var/albums/Premium/Light-Side/orbedestroyed.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@ecc_obj_line)
      @card_importer.send(:card_back_image_url).should == "http://starwarsccg.org/gallery/var/albums/Premium/Light-Side/independentoperation.gif"
    end
    
    it "returns a string url for the given card" do
      @card = @card_importer.import(@third_anthology_line)
      @card_importer.send(:card_back_image_url).should == "http://starwarsccg.org/cards/3RD_ANTHOLOGY/theultimatepowerintheunive.gif"
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
      @card_importer.should_receive(:import).exactly(24).times
      @card_importer.import_file('spec/fixtures/import_test.cdf')
    end
    
    it "imports a card for each line of the file" do
      lambda {
        @card_importer.import_file('spec/fixtures/import_test.cdf')
      }.should change {Card.count}.by 23
    end
    
    it "logs errors on the model" do
      Rails.logger.should_receive(:error).at_least(1).times
      @card_importer.import_file('spec/fixtures/import_test.cdf')
    end
  end
end