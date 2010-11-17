class CardImporter
  attr_accessor :card
  
  def initialize
    @card = Card.new
  end
  
  def import(card_string)
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
        Rails.logger.error "Card image url #{self.card_image_url || 'nil'} failed for #{@card.id}: #{@card.title}" if @card.valid?
      end
      
      begin
        @card.card_back_image = open(URI.parse(self.card_back_image_url)) if @card.is_flippable?
      rescue
        Rails.logger.error "Card back image url #{self.card_back_image_url || 'nil'} failed for #{@card.id}: #{@card.title}" if @card.valid?
      end
      
      begin
        @card.vslip_image = open(URI.parse(self.vslip_image_url))
      rescue
        Rails.logger.error "V-slip url #{self.vslip_image_url || 'nil'} failed for #{@card.id}: #{@card.title}" if @card.valid?
      end
      
      begin
        @card.vslip_back_image = open(URI.parse(self.vslip_back_image_url))
      rescue
        Rails.logger.error "V-slip back url #{self.vslip_back_image_url || 'nil'} failed for #{@card.id}: #{@card.title}" if @card.valid?
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
  
  def self.import_file(filename)
    file = File.new(filename,"r")
    while (line = file.gets)
      importer = CardImporter.new
      card = importer.import(line)
      card.save! unless card.nil?
      Rails.logger.error card.errors.full_messages if card.errors
    end
    file.close
  end
  
  protected
  
  def card_image_url
    if @card.is_flippable?
      filename = @card.title.split('/').first
    else
      filename = @card.title
    end
    image_url = "http://swccgpc.com/gallery/var/albums/#{@card.expansion.gsub(' ', '-').gsub(/'/, '')}/#{@card.side}-Side/#{filename.downcase.gsub('&','%26').gsub(/[^0-9a-z]/i, '')}.gif"
    image_url.gsub!('Reflections', 'Reflections/Reflections') if @card.expansion =~ /Reflections/
 
    image_url
  end
  
  def card_back_image_url
    if @card.is_flippable?
      filename = @card.title.split('/').last
      image_url = "http://swccgpc.com/gallery/var/albums/#{@card.expansion.gsub(' ', '-').gsub(/'/, '')}/#{@card.side}-Side/#{filename.downcase.gsub('(V)','').gsub('(v)','').gsub('&','%26').gsub(/[^0-9a-z]/i, '')}.gif"
      image_url.gsub!('Reflections', 'Reflections/Reflections') if @card.expansion =~ /Reflections/
    end
    
    image_url
  end
  
  def vslip_image_url
    if @card.is_virtual?
      vslip_image_url_root = "http://stuff.ledwards.com/starwars"
      vslip_file_ext = ".png"
      front, back = @card.title.split('/')
    
      if @card.is_flippable?
        front, back = @card.title.split('/')
        vslip_image_url = vslip_image_url_root + '/' + @card.side.downcase + '/' + front.downcase.gsub(" ","").gsub("'","").gsub("(","").gsub(")","").gsub(":","").gsub("?","").gsub("!","").gsub("-","").gsub(",","") + vslip_file_ext
      else
        vslip_image_url = vslip_image_url_root + '/' + @card.side.downcase + '/' + @card.title.downcase.gsub(" ","").gsub("'","").gsub("(","").gsub(")","").gsub(":","").gsub("?","").gsub("!","").gsub("-","").gsub(",","") + vslip_file_ext
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
        vslip_back_image_url = vslip_image_url_root + '/' + @card.side.downcase + '/' + back.downcase.gsub('(V)','').gsub('(v)','').gsub(" ","").gsub("'","").gsub("(","").gsub(")","").gsub(":","").gsub("?","").gsub("!","").gsub("-","").gsub(",","") + vslip_file_ext
      end
    end
     
    vslip_back_image_url
  end
  
end