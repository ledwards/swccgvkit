# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Role.create(:name => "owner")
# admin_role = Role.create(:name => "admin")
# Role.create(:name => "card admin")
# 
# admin = User.new(:email => "admin@swccgvkit.com", :password => "password", :password_confirmation => "password")
# admin.roles << admin_role
# admin.save!

#!/usr/bin/env ruby
require 'config/environment'

counter = 1
files = ["#{RAILS_ROOT}/db/lightside.cdf", "#{RAILS_ROOT}/db/darkside.cdf"]
# url_root = "/images/cards"
# file_ext = ".gif"

dry = false

files.each do |curfile|
  file = File.new(curfile,"r") #do both files
  while (line=file.gets)
    
    characteristics = []
    attributes = []

    icons = nil    
    image_url = nil
    uniqueness = nil
    title = nil
    destiny = nil
    side = nil
    type = nil
    rarity = nil
    expansion = nil
    subtype = nil
    # image_front_url = nil
    # image_back_url = nil
    # image_url = nil
    
    ferocity = nil
    power = nil
    ability = nil
    politics = nil
    armor = nil
    maneuver = nil
    landspeed = nil
    hyperspeed = nil
    deploy = nil
    forfeit = nil
    
    gametext = nil
    lore = nil
    destiny = nil
    
    regexp1 = /card\s"(.*?)"\s"([<>ï]*)(.*)\(([^V]*)\)\\n(\S*)\s(.*?)\[(.*)\]\s?\\nSet:\s(.*?)\\n/ #Basic card info
    
    if not regexp1.match(line).nil?
      image_url,uniqueness,title,destiny,side,type,rarity,expansion = regexp1.match(line).captures
      
      # Type and subtype
      
      if not /(.*)\s-\s(.*):(.*)/.match(type).nil?
        subtype = /(.*)\s-\s(.*):(.*)/.match(type).captures[1]
        characteristics << /(.*)\s-\s(.*):(.*)/.match(type).captures[2]
        type = /(.*)\s-\s(.*)/.match(type).captures[0]
      elsif not /(.*)\s-\s(.*)/.match(type).nil?
        type, subtype = /(.*)\s-\s(.*)/.match(type).captures
      end
      
      if type == 'Effect' or type == 'Interrupt'
        subtype << ' ' << type
      end
      
      # set back image
      
      # if not image_url.scan(/TWOSIDED/).empty?
      #         image_url.sub!('/TWOSIDED/','')
      #         root, front, back = /(.*\/)(.*)\/(.*)/.match(image_url).captures
      #         image_front_url = url_root + '/' + root + front + file_ext
      #         image_back_url = url_root + '/' + root + 't_' + back + file_ext
      #       elsif side == 'Dark'
      #         image_front_url = url_root + image_url + file_ext
      #         image_back_url = url_root + '/imp' + file_ext
      #       elsif side == 'Light'
      #         image_front_url = url_root + image_url + file_ext
      #         image_back_url = url_root + '/reb' + file_ext
      #       end
      
       # format uniqueness for HTML/XML
      uniqueness.gsub!('ï','&bull;')
      uniqueness.gsub!('<>',"&#9671;")
      title.gsub!('ï','') #for combo cards like ïAbyssin Ornament & ïWounded Wookiee
      title.strip!
      type.strip!

      # debug output
      #puts "#{counter}: #{uniqueness} #{title} (#{destiny})"
      #puts image_front_url, image_back_url
      #puts side
      #puts type
      if subtype
        subtype.strip!
        #puts subtype
      end
      #puts expansion, rarity
    
      # ATTRIBUTES #
    
      regexp2 = /Ferocity: (.+?)/
      if not regexp2.match(line).nil?
        ferocity = regexp2.match(line).captures[0]
        #puts "Ferocity: #{ferocity}"
      end
    
      regexp2 = /Power: (.+?)/
      if not regexp2.match(line).nil?
        power = regexp2.match(line).captures[0]
        #puts "Power: #{power}"
      end
      
      regexp2 = /Ability: (.+?)/
      if not regexp2.match(line).nil?
        ability = regexp2.match(line).captures[0]
        #puts "Ability: #{ability}"
      end
      
       regexp2 = /Politics: (.+?)/
      if not regexp2.match(line).nil?
        politics = regexp2.match(line).captures[0]
        #puts "Politics: #{politics}"
      end
      
      regexp2 = /Armor: (.+?)/
      if not regexp2.match(line).nil?
        armor = regexp2.match(line).captures[0]
        #puts "Armor: #{armor}"
      end
      
      regexp2 = /Maneuver: (.+?)/
      if not regexp2.match(line).nil?
        maneuver = regexp2.match(line).captures[0]
        #puts "Maneuver: #{maneuver}"
      end
      
      regexp2 = /Hyperspeed: (.+?)/
      if not regexp2.match(line).nil?
        hyperspeed = regexp2.match(line).captures[0]
        #puts "Hyperspeed: #{hyperspeed}"
      end
      
      regexp2 = /Landspeed: (.+?)/
      if not regexp2.match(line).nil?
        landspeed = regexp2.match(line).captures[0]
        #puts "Landspeed: #{landspeed}"
      end
      
      regexp2 = /Deploy: (.+?)/
      if not regexp2.match(line).nil?
        deploy = regexp2.match(line).captures[0]
        #puts "Deploy: #{deploy}"
      end
      
      regexp2 = /Forfeit: (.+?)/
      if not regexp2.match(line).nil?
        forfeit = regexp2.match(line).captures[0]
        #puts "Forfeit: #{forfeit}"
      end
      
      # other stuff
      
      regexp5 = /Icons: (.+?)\\n/
      if not regexp5.match(line).nil?
        icons = regexp5.match(line).captures[0]
      end
      
      regexp3 = /Lore: (.*)\\n/
      if not regexp3.match(line).nil?
        lore = regexp3.match(line).captures[0].sub('\n','')
        #puts lore
      end
      
      #puts
      
      regexp4 = /Text: (.*)"/
      if not regexp4.match(line).nil?
        gametext = regexp4.match(line).captures[0].sub('\n','')
        gametext.gsub!('ï','&bull;')
        gametext.gsub!("<>","&#9671;")
        gametext.gsub!('\\n','<br />')
        #puts gametext
      end
      
      regexp4a = /\\n\\n(.*)"/
      if type == "Objective"
        gametext = regexp4a.match(line).captures[0]
        gametext.gsub!('\\n','<br />')
      end
      
      
      # CHARACTERISTICS #
      if icons
        if type == 'Starship' or type == 'Vehicle'
          icons.sub!('Pilot','Permanent Pilot')
        end
        if type == "Location"
          icons.sub!('Space','')
        end
        icons.each_line(separator=','){ |icon| characteristics << icon.delete(',').strip}
      end
      
      if ability == '3'
        characteristics << 'Force Attuned'
      end
      
      if ability == '4' or ability == '5'
        characteristics << 'Force Sensitive'
      end
      
      if ability == '6' and side == 'Dark'
        characteristics << 'Dark Jedi'
      end
      
      if ability == '6' and side == 'Light'
        characteristics << 'Jedi Knight'
      end
      
      if ability == '7' and side == 'Dark'
        characteristics << 'Dark Jedi Master'
      end
      
      if ability == '7' and side == 'Light'
        characteristics << 'Jedi Master'
      end
      
      #puts characteristics
      
      ###############
      # write to DB #
      ###############
      
      if dry
        #puts 'Dry run complete'
      else
        # Disabled parameters
        # :image_front_url => image_front_url,
        # :image_back_url => image_back_url,
        begin
          this_card = Card.new(:id => counter,
                      :title => title,
                      :lore => lore,
                      :gametext => gametext,
                      :side => side,
                      :expansion => expansion,
                      :rarity => rarity,
                      :uniqueness => uniqueness,
                      :card_characteristics => [],
                      :card_type => type,
                      :subtype => subtype
                      )
          this_card.save
          
          for c in characteristics
            if existing_characteristic = CardCharacteristic.find_by_name(c)
              ##puts "EXISTING CHARACTERISTIC: #{existing_characteristic.name}"
              this_card.card_characteristics << existing_characteristic
            else
              ##puts "NEW CHARACTERISTIC: #{c}"
              new_card_characteristic = CardCharacteristic.create(:name => c)
              this_card.card_characteristics << new_card_characteristic
            end
          end
         
          if destiny
            a = CardAttribute.create :name => "Destiny", :value => destiny.to_i
            this_card.card_attributes << a
          end
          
          if ferocity
            a = CardAttribute.create :name => "Ferocity", :value => ferocity.to_i
            this_card.card_attributes << a
          end
          
          if power
            a = CardAttribute.create :name => "Power", :value => power.to_i
            this_card.card_attributes << a
          end
          
          if ability
            a = CardAttribute.create :name => "Ability", :value => ability.to_i
            this_card.card_attributes << a
          end
          
          if politics
            a = CardAttribute.create :name => "Politics", :value => politics.to_i
            this_card.card_attributes << a
          end
          
          if armor
            a = CardAttribute.create :name => "Armor", :value => armor.to_i
            this_card.card_attributes << a
          end
          
          if maneuver
            a = CardAttribute.create :name => "Maneuever", :value => maneuver.to_i
            this_card.card_attributes << a
          end
          
          if landspeed
            a = CardAttribute.create :name => "Landspeed", :value => landspeed.to_i
            this_card.card_attributes << a
          end
          
          if hyperspeed
            a = CardAttribute.create :name => "Hyperspeed", :value => hyperspeed.to_i
            this_card.card_attributes << a
          end
          
          if deploy
            a = CardAttribute.create :name => "Deploy", :value => deploy.to_i
            this_card.card_attributes << a
          end
          
          if forfeit
            a = CardAttribute.create :name => "Forfeit", :value => forfeit.to_i
            this_card.card_attributes << a
          end
        
        rescue
          #puts "Error with card #{title}"
          
        end
        
      end

      
      #puts
      #puts
      
      #puts title
      
    end
    
    counter = counter +1
  end
  
  file.close
  
  #puts curfile
end



# script fixes
  # characteristics sometimes have leading and trailing spaces
  # droid types
  # creature defense
  # lore and gametext-based characteristics, gender