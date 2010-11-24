class CardImporter
  attr_accessor :card
  
  def initialize
    @card = Card.new
  end
  
  def import_file(filename)
    # TODO: skip AI cards
    file = File.open(filename,"r")
    while (line = file.gets)
      begin
        @card = import(line)
        @card.save! unless @card.nil?
        Rails.logger.error @card.errors.full_messages unless @card.nil?
      rescue
        Rails.logger.error "Something went wrong with #{line}"
      end
    end
    file.close
  end
  
  def import(card_string)
    @card = Card.new
    card_re = /card\s"(.*?)"\s"([<>@]*)(.*)\(([^V]*)\)\\n(\S*)\s(.*?)\[(.*)\]\s?\\nSet:\s(.*?)\\n/
    card_type_re = /(.*)\s-\s(\w*)(:*\s*.*)/
    icons_re = /Icons: (.+?)\\n/
    gametext_re = /Text: (.*)"/
    obj_gametext_re = /\\n\\n(.*)"/ 

    characteristics = []
    
    if card_re.match(card_string).nil?
      return nil
    else
      card_match = card_re.match(card_string)
      
      image_url = card_match.captures[0]
      @card.uniqueness = card_match.captures[1]
      @card.title = card_match.captures[2].strip
      @card.card_attributes << CardAttribute.new(:name => "Destiny", :value => card_match.captures[3])
      @card.side = card_match.captures[4].strip
      @card.card_type = card_match.captures[5].strip
      @card.rarity = card_match.captures[6].strip
      @card.expansion = card_match.captures[7].strip
      
      if card_type_match = card_type_re.match(@card.card_type)
        characteristics << card_type_match.captures[2] if card_type_match.captures[2].any?
        @card.subtype = card_type_match.captures[1]
        @card.card_type = card_type_match.captures[0]
      end
      
      if ["Effect", "Interrupt", "Weapon", "Vehicle"].include?(@card.card_type)
        @card.subtype = "#{@card.subtype} #{@card.card_type}"
      end
      
      if @card.uniqueness.nil?
        @card.uniqueness = ""
      else
        @card.uniqueness.gsub!('@','•')
        @card.uniqueness.gsub!('<>','◊')
        @card.title.gsub!('@','') #for unique combo cards who have residual uniquenesses in them
      end
       
      begin
        @card.card_image = open(URI.parse(self.card_image_url))
      rescue
        Rails.logger.info "Card image url failed for #{@card.id}: #{@card.title}" if @card.valid?
      end
      
      begin
        @card.card_back_image = open(URI.parse(self.card_back_image_url)) if @card.is_flippable?
      rescue
        Rails.logger.info "Card back image url failed for #{@card.id}: #{@card.title}" if @card.valid?
      end
      
      begin
        @card.vslip_image = open(URI.parse(self.vslip_image_url)) if @card.is_virtual?
      rescue
        Rails.logger.info "V-slip url failed for #{@card.id}: #{@card.title}" if @card.valid?
      end
      
      begin
        @card.vslip_back_image = open(URI.parse(self.vslip_back_image_url)) if @card.is_virtual? && @card.is_flippable?
      rescue
        Rails.logger.info "V-slip back url failed for #{@card.id}: #{@card.title}" if @card.valid?
      end
      
      
      attribute_names = ["Ferocity", "Power", "Ability", "Politics", "Armor", "Maneuever", "Hyperspeed", "Landspeed", "Deploy", "Forfeit"]
      attributes = []
      attribute_names.each do |a| 
        attribute = find_attribute(a, card_string)
        @card.card_attributes << attribute if attribute
        @ability = attribute.value if attribute && a == "Ability"
      end
      
      if icons_re.match(card_string) && icons = icons_re.match(card_string).captures[0]
        icons.sub!('Pilot','Permanent Pilot') if @card.card_type == 'Starship' or card.card_type == 'Vehicle'
        icons.sub!('Space','') if @card.card_type == "Location"          
        
        icons.each_line(separator=',') do |icon|
          characteristics << icon.delete(',').strip
        end
      end
      
      characteristics << 'Force Attuned' if @ability == '3'
      characteristics << 'Force Sensitive' if @ability == '4' or @ability == '5'        
      characteristics << 'Dark Jedi' if @ability == '6' and @card.side == 'Dark'
      characteristics << 'Jedi Knight' if @ability == '6' and @card.side == 'Light'
      characteristics << 'Dark Jedi Master' if @ability == '7' and @card.side == 'Dark'
      characteristics << 'Jedi Master' if @ability == '7' and @card.side == 'Light'
      
      characteristics.each do |c|
        @card.card_characteristics << CardCharacteristic.find_or_create_by_name(c) unless c.nil?
      end
      
      lore_re = /Lore: (.*)\\n/
      @card.lore = lore_re.match(card_string).captures[0].sub('\n','') if not lore_re.match(card_string).nil?
      
      if @card.card_type == "Objective"
        @card.gametext = obj_gametext_re.match(card_string).captures[0].gsub("\n",'<br />')
      else
        @card.gametext = gametext_re.match(card_string).captures[0].strip.sub('\n','').gsub('ï','•').gsub("<>","◊").gsub("\n",'<br />') if not gametext_re.match(card_string).nil?
      end
      
    end
    
    return @card
  end
  
  def find_attribute(attr_name, card_string)
    attr_re = /#{attr_name}: (.+?)/
    if attr_re.match(card_string)
      value = attr_re.match(card_string).captures[0]
      return CardAttribute.new(:name => attr_name, :value => value)
    else
      return nil
    end
  end
  
  protected
  
  def subdirectory_for_card_image
    exceptions = {
      "Theed Palace" => "cards",
      "Virtual Block 6" => "cards",
      "Third Anthology" => "cards"
    }
    exceptions[@card.expansion] || "gallery/var/albums"
  end
  
  def expansion_for_card_image
    exceptions = {
      "Theed Palace" => "THEED",
      "Third Anthology" => "3RD_ANTHOLOGY",
      "Virtual Block 6" => "v6",
      "Jedi Pack" => "Premium",
      "Premiere Introductory Two Player Game" => "Premium",
      "Empire Strikes Back Introductory Two Player Game" => "Premium",
      "Enhanced Jabba's Palace" => "Premium",
      "Enhanced Cloud City" => "Premium",
      "Official Tournament Sealed Deck" => "Premium",
      "Jabba's Palace Sealed Deck" => "Premium",
      "Enhanced Premiere" => "Premium",
      "Rebel Leader Pack" => "Premium"
    }
    
    subdir = {
      "Reflections II" => "Reflections/",
      "Reflections III" => "Reflections/"
    }
    exceptions[@card.expansion] || "#{subdir[@card.expansion]}#{@card.expansion.gsub(" ","-").gsub("'","")}"
  end
  
  def side_for_card_image
    exceptions = {
      "Theed Palace" => @card.side.first.upcase + "S/",
      "Virtual Block 6" => @card.side.first.downcase + "s/",
      "Third Anthology" => ""
    }
    exceptions[@card.expansion] || "#{@card.side}-Side/"
  end
  
  def filename_for_card_image
    exceptions = {
      "Brangus Glee" => "brangussglee"
    }
    
    transformations = {
      "Objective" => @card.title.split('/').first,
      "Character - Droid" => self.filename_for_droid
    }
    exceptions[@card.title] || self.transform_filename(transformations[@card.card_type_and_subtype] || @card.title)
  end
  
  def filename_for_card_back_image
    exceptions = {
      "Set Your Course For Alderaan/The Ultimate Power In The Universe" => "theultimatepowerintheunive"
    }
    exceptions[@card.title] || self.transform_filename(@card.title.split('/').last)
  end
  
  def filename_for_droid
    exceptions = ["Premiere", "A New Hope", "Special Edition", "Virtual Block 1"]
    exceptions.include?(@card.expansion) ? @card.title.gsub(/\(.+\)/,"") : @card.title
  end
  
  def transform_filename(filename)
    filename.gsub("(V)","").gsub("(v)","").gsub("&", '%26').downcase.gsub(/[^0-9a-z%]/i, "")
  end
  
  def extension_for_card_image
    exceptions = {
      "Theed Palace" => "jpg",
      "Coruscant" => "jpg",
      "Tatooine" => "jpg",
      "Virtual Block 6" => "JPG"
    }
    exceptions[@card.expansion] || "gif"
  end
  
  def card_image_url
    url_root = "http://starwarsccg.org"
    image_url = "#{url_root}/#{self.subdirectory_for_card_image}/#{self.expansion_for_card_image}/#{self.side_for_card_image}#{self.filename_for_card_image}.#{self.extension_for_card_image}"
  end
  
  def card_back_image_url
    return nil unless @card.card_type == "Objective"
    
    url_root = "http://starwarsccg.org"
    image_url = "#{url_root}/#{self.subdirectory_for_card_image}/#{self.expansion_for_card_image}/#{self.side_for_card_image}#{self.filename_for_card_back_image}.#{self.extension_for_card_image}"
  end
  
  def vslip_image_url
    if @card.is_virtual?
      vslip_image_url_root = "http://stuff.ledwards.com/starwars"
      vslip_file_ext = ".png"
      front, back = @card.title.split('/')
    
      if @card.is_flippable?
        front, back = @card.title.split('/')
        vslip_image_url = vslip_image_url_root + '/' + @card.side.downcase + '/' + front.downcase.gsub(" ","").gsub("'","").gsub("(","").gsub(")","").gsub(":","").gsub("?","").gsub("!","").gsub("-","").gsub(",","").gsub("&","") + vslip_file_ext
      else
        vslip_image_url = vslip_image_url_root + '/' + @card.side.downcase + '/' + @card.title.downcase.gsub(" ","").gsub("'","").gsub("(","").gsub(")","").gsub(":","").gsub("?","").gsub("!","").gsub("-","").gsub(",","").gsub("&","") + vslip_file_ext
      end
    end

    vslip_image_url
  end
  
  def vslip_back_image_url
    if @card.is_virtual?
      vslip_image_url_root = "http://stuff.ledwards.com/starwars"
      vslip_file_ext = ".png"    
      front, back = @card.title.split('/')
    
      if @card.is_flippable?
        front, back = @card.title.split('/')
        vslip_back_image_url = vslip_image_url_root + '/' + @card.side.downcase + '/' + back.downcase.gsub('(V)','').gsub('(v)','').gsub(" ","").gsub("'","").gsub("(","").gsub(")","").gsub(":","").gsub("?","").gsub("!","").gsub("-","").gsub(",","").gsub("&","") + vslip_file_ext
      end
    end
     
    vslip_back_image_url
  end
  
end