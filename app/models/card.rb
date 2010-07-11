class Card < ActiveRecord::Base
  validates_presence_of :title, :card_type, :expansion
  
  has_attached_file :card_image,
    :styles => { :full_size => "350", :thumbnail =>"100" },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :path => "card_images/:id/:style.:extension"
    
  has_attached_file :vslip_image,
    :styles => { :full_size => "350" },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :path => "vslip_images/:id/:style.:extension"
    
  has_attached_file :card_back_image,
    :styles => { :full_size => "350", :thumbnail =>"100" },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :path => "card_back_images/:id/:style.:extension"
    
  has_attached_file :vslip_back_image,
    :styles => { :full_size => "350" },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :path => "vslip_back_images/:id/:style.:extension"

    def has_card_image?
      return !card_image_file_name.nil?
    end

    def has_vslip_image?
      return !vslip_image_file_name.nil?
    end
    
    def has_vslip_back_image?
      return !vslip_back_image_file_name.nil?
    end

    def formatted_title
      return uniqueness + title
    end

    def truncated_title(trunc_length)
      if title.length > trunc_length
        title.first(trunc_length) + "..."
      else
        title
      end
    end

  def self.new_card_from_holotable_line(line)
    card_re = /card\s"(.*?)"\s"([<>ï]*)(.*)\(([^V]*)\)\\n(\S*)\s(.*?)\[(.*)\]\s?\\nSet:\s(.*?)\\n/
    
    if card_re.match(line).nil?
      card = nil
    else
      image_url,uniqueness,title,destiny,side,type,rarity,expansion = card_re.match(line).captures
      title.gsub!('ï','')
      title.strip!
      type.strip!
      
      vslip_file_name = "/images/vslips" + image_url.gsub("/t_","/").gsub("/starwars","") + ".png"
      card_image_file_name = "http://www.swccgonline.com/images/cards" + image_url + ".gif"
      
      if type == "Objective"
        objective_re = /(.+)\s?\/\s?(.+)/ # split Front and Back of Objective
        front, back = objective_re.match(title).captures
        
        vslip_file_name.gsub!("TWOSIDED/", "")
        back_vslip_file_name = vslip_file_name.gsub(front,back)        
        back_card_image_file_name = card_image_file_name.gsub(front,back)
      end
        
      card = Card.new(:title => title,
                      :side => side,
                      :expansion => expansion,
                      :card_type => type)

      # if File.exist? vslip_file_name
      #   card.vslip = File.open(vslip_file_name)
      # end
      # 
      # if File.exist? card_image
      #   card.card_image = File.open(card_image)
      # end
      # 
      # if File.exist? back_vslip_file_name
      #   card.back_vslip = File.open(back_vslip_file_name)
      # end
      # 
      # if File.exist? back_card_image
      #   card.back_card_image = File.open(back_card_image_file_name)
      # end

    end
    return card
  end
  
  def self.get_cards_from_card_file(filename)
    cards = []
    file = File.new(filename,"r") #do both files
    while (line = file.gets)
      cards << Card.new_card_from_holotable_line(line)
    end
    return cards
  end
  
end
