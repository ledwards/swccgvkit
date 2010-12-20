require 'spec_helper'

describe Card do
  fixtures :cards
  
  before :each do
    @card = Card.new(:title => "Darth Vader", :card_type => "Character", :subtype => "Imperial", :expansion => "Premiere", :lore => "darthvaderslore", :gametext => "darthvadersgametext")
    @power4 = CardAttribute.create(:name => "Power", :value => "4")
    @armor5 = CardAttribute.create(:name => "Armor", :value => "5")
    @card.card_attributes << @power4
    @test_image = File.open("#{Rails.root}/spec/fixtures/test.jpg")
  end
  
  it "has a Factory" do
    Factory(:card).should be
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
  
  it "is unique among title, side, and expansion" do
    pending
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
  
  describe "#has_card_image?" do
    it "is true if there is a valid card image" do
      @card.save!
      @card.card_image = @test_image
      @card.has_card_image?.should be_true
    end
    it "is false if there is an invalid card image" do
      @card.has_card_image?.should be_false
    end
  end
  
  describe "#has_card_back_image?" do
    it "is true if there is a valid card back image" do
      @card.save!
      @card.card_back_image = @test_image
      @card.has_card_back_image?.should be_true
    end
    it "is false if there is an invalid card image" do
      @card.has_card_back_image?.should be_false
    end
  end
  
  describe "#has_vslip_image?" do
    it "is true if there is a valid vslip image" do
      @card.save!
      @card.vslip_image = @test_image
      @card.has_vslip_image?.should be_true
    end
    it "is false if there is an invalid card image" do
      @card.has_vslip_image?.should be_false
    end
  end
  
  describe "#has_vslip_back_image?" do
    it "is true if there is a valid vslip back image" do
      @card.save!
      @card.vslip_back_image = @test_image
      @card.has_vslip_back_image?.should be_true
    end
    it "is false if there is an invalid card image" do
      @card.has_vslip_back_image?.should be_false
    end
  end
  
  describe "#attach_local_card_image" do
    it "attaches an image from a path as the specified attachment" do
      @card.attach_local_card_image("#{Rails.configuration.card_image_import_path}/Premiere-Dark/darthvader.gif")
      @card.has_card_image?.should be_true
    end
  end
  
  describe "#attach_local_card_back_image" do
    it "attaches an image from a path as the specified attachment" do
      @card.attach_local_card_back_image("#{Rails.configuration.card_image_import_path}/Premiere-Dark/darthvader.gif")
      @card.has_card_back_image?.should be_true
    end
  end

  describe "#attach_local_vslip_image" do
    it "attaches a vslip image from a path as the specified attachment" do
      @card.attach_local_vslip_image("#{Rails.configuration.vslip_image_import_path}/dark/darthvader.png")
      @card.has_vslip_image?.should be_true
    end
  end

  describe "#attach_local_vslip_back_image" do
    it "attaches a vslip back image from a path as the specified attachment" do
      @card.attach_local_vslip_back_image("#{Rails.configuration.vslip_image_import_path}/dark/darthvader.png")
      @card.has_vslip_back_image?.should be_true
    end
  end
  
  describe "#attach_remote_card_image" do
    use_vcr_cassette 'cards/attach_remote_card_image', :record => :new_episodes
    
    it "attaches an image from a remote url as the specified attachment" do
      @card.attach_remote_card_image("http://starwarsccg.org/gallery/var/albums/Premiere/Dark-Side/darthvader.gif")
      @card.has_card_image?.should be_true
    end
  end
  
  describe "#attach_remote_card_back_image" do
    use_vcr_cassette 'cards/attach_remote_card_back_image', :record => :new_episodes

    it "attaches an image from a remote url as the specified attachment" do
      @card.attach_remote_card_back_image("http://starwarsccg.org/gallery/var/albums/Premiere/Dark-Side/darthvader.gif")
      @card.has_card_back_image?.should be_true
    end
  end

  describe "#attach_remote_vslip_image" do
    use_vcr_cassette 'cards/attach_remote_vslip_image', :record => :new_episodes

    it "attaches a vslip image from a remote url as the specified attachment" do
      @card.attach_remote_vslip_image("http://starwarsccg.org/gallery/var/albums/Premiere/Dark-Side/darthvader.gif")
      @card.has_vslip_image?.should be_true
    end
  end

  describe "#attach_remote_vslip_back_image" do
    use_vcr_cassette 'attach_remote_vslip_back_image', :record => :new_episodes

    it "attaches a vslip back image from a remote url as the specified attachment" do
      @card.attach_remote_vslip_back_image("http://starwarsccg.org/gallery/var/albums/Premiere/Dark-Side/darthvader.gif")
      @card.has_vslip_back_image?.should be_true
    end
  end
  
  describe "#card_type_and_subtype" do
    it "returns just subtype for Effect, Interrupt, Weapon, Vehicle" do
      @lost_interrupt = Factory(:card, :card_type => "Interrupt", :subtype => "Lost Interrupt")
      @lost_interrupt.card_type_and_subtype.should == "Lost Interrupt"
    end
    
    it "returns the type - cardtype otherwise" do
      @card.card_type_and_subtype.should == "#{@card.card_type} - #{@card.subtype}"
    end
  end
  
  describe ".missing_images" do    
    before do
      @card = Factory.create(:card, :card_image => @test_image)
      @virtual_card = Factory.create(:card, :expansion => "Virtual Block 10", :card_image => @test_image, :vslip_image => @test_image)
      @objective = Factory.create(:card, :card_type => "Objective", :card_image => @test_image, :card_back_image => @test_image)
      @virtual_objective = Factory.create(:card, :expansion => "Virtual Block 10", :card_type => "Objective", :card_image => @test_image, :card_back_image => @test_image, :vslip_image => @test_image, :vslip_back_image => @test_image)
    end
    
    it "will not return cards with images that have been set" do
      @missing_images = Card.missing_images
      @missing_images.include?(@card).should be_false
      @missing_images.include?(@virtual_card).should be_false
      @missing_images.include?(@objective).should be_false
      @missing_images.include?(@virtual_objective).should be_false
    end
    
    it "returns cards with images that have not been set on cards that should have them" do
      @card.update_attribute(:card_image, nil)
      @virtual_card.update_attribute(:vslip_image, nil)
      @objective.update_attribute(:card_back_image, nil)
      @virtual_objective.update_attribute(:vslip_back_image, nil)

      @missing_images = Card.missing_images
      @missing_images.include?(@card).should be_true
      @missing_images.include?(@virtual_card).should be_true
      @missing_images.include?(@objective).should be_true
      @missing_images.include?(@virtual_objective).should be_true
    end
  end
end
