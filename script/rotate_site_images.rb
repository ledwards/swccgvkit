require "config/environment.rb"

@server = "http://stuff.ledwards.com/starwars"
files = ["#{Rails.root}/db/lightside.cdf", "#{Rails.root}/db/darkside.cdf"]
card_re = /card\s"(.*?)"\s"([<>@•]*)(.*)\(([^V]*)\)\\n(\S*)\s(.*?)\[(.*)\]\s?\\nSet:\s(.*?)\\n/


def subdir_for_local_card_image
  "#{@card.expansion.gsub("'","").gsub(" ","").gsub("Block","")}-#{@card.side}"
end

def card_image_path
  return nil if @card.invalid?
  "#{Rails.configuration.card_image_import_path}/#{subdir_for_local_card_image}/#{filename_for_card_image}.gif"
end

def filename_for_card_image
  filename_re = /t_(.*)" "/
  filename_re.match(@card_string).captures[0].split("/").first
end


files.each do |filename|
  file = File.open(filename,"r")

  while (@card_string = file.gets)
    if card_match = card_re.match(@card_string)
      begin
        image_url = card_match.captures[0]
        title = card_match.captures[2].strip.gsub("@","").gsub("•","")
        side = card_match.captures[4].strip
        card_type, subtype = card_match.captures[5].strip.split(" - ")
        expansion = card_match.captures[7].strip
        expansion.gsub!("2 Player", "Two Player")
        
        @card = Card.find_by_title_and_expansion_and_side(title, expansion, side)

        if @card.present? && subtype == "Site"
          %x[mogrify -rotate "180" #{card_image_path}]
          p @card.title

          @card.card_image = File.open(card_image_path)
          @card.save! unless @card.nil?
        end

      end
    end
  end

  file.close
end

