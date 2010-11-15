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
    
    vslip_url_root = "http://stuff.ledwards.com/starwars"
    vslip_file_ext = ".png"    

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
            
      if @card.is_flippable?
        front, back = @card.title.split('/')
        image_url = "http://swccgpc.com/gallery/var/albums/#{@card.expansion.gsub(' ','-')}/#{@card.side}-Side/#{front.downcase.gsub('&','%26').gsub(/[^0-9a-z]/i, '')}.gif"
        image_back_url = "http://swccgpc.com/gallery/var/albums/#{@card.expansion.gsub(' ','-')}/#{@card.side}-Side/#{back.gsub(' (V)','').downcase.gsub('&','%26').gsub(/[^0-9a-z]/i, '')}.gif"
        [image_url, image_back_url].each {|u| u.gsub!('Reflections', 'Reflections/Reflections') if @card.expansion =~ /Reflections/}
        begin
          @card.card_image = open(URI.parse(image_url))
        rescue
          puts "Card image url #{image_url} failed for #{@card.id}: #{@card.title}"
        end
        begin
          @card.card_back_image = open(URI.parse(image_back_url))
        rescue
          puts "Card back image url #{image_back_url} failed for #{@card.id}: #{@card.title}"
        end
        
        if @card.is_virtual?
          vslip_url = vslip_url_root + '/' + @card.side.downcase + '/' + front.downcase.gsub(" ","").gsub("'","").gsub("(","").gsub(")","").gsub(":","").gsub("?","").gsub("!","").gsub("-","").gsub(",","") + vslip_file_ext
          vslip_back_url = vslip_url_root + '/' + @card.side.downcase + '/' + back.downcase.gsub(" ","").gsub("'","").gsub("(","").gsub(")","").gsub(":","").gsub("?","").gsub("!","").gsub("-","").gsub(",","") + vslip_file_ext
          vslip_back_url.gsub!("v.png",".png")
          
          begin
            @card.vslip_image = open(URI.parse(vslip_url))
          rescue
            puts "V-slip url #{vslip_url} failed for #{@card.id}: #{@card.title}"
          end
          begin
            @card.vslip_back_image = open(URI.parse(vslip_back_url))
          rescue
            puts "V-slip back url #{vslip_back_url} failed for #{@card.id}: #{@card.title}"
          end
        end

      else
        image_url = "http://swccgpc.com/gallery/var/albums/#{@card.expansion.gsub(' ','-')}/#{@card.side}-Side/#{@card.title.downcase.gsub('&','%26').gsub(/[^0-9a-z]/i, '')}.gif"
        image_url.gsub!('Reflections', 'Reflections/Reflections') if @card.expansion =~ /Reflections/
        
        begin
          @card.card_image = open(URI.parse(image_url))
        rescue
          puts "Card image url #{image_url} failed for #{@card.id}: #{@card.title}"
        end
        
        if @card.is_virtual?
          vslip_url = vslip_url_root + '/' + @card.side.downcase + '/' + @card.title.downcase.gsub("(v)","").gsub(" ","").gsub("'","").gsub("(","").gsub(")","").gsub(":","").gsub("?","").gsub("!","").gsub("-","").gsub(",","") + vslip_file_ext
          begin
            @card.vslip_image = open(URI.parse(vslip_url))
          rescue
            puts "V-slip url #{vslip_url} failed for #{@card.id}: #{@card.title}"
          end
        end
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
  
  def import_file(file)
  end
  
end