class Card < ActiveRecord::Base
  validates_presence_of :title, :card_type, :expansion
  
  has_and_belongs_to_many :card_characteristics
  has_many :card_attributes
  
  accepts_nested_attributes_for :card_attributes
  
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
    
  scope :virtual, lambda {
    where("cards.expansion LIKE ?", "Virtual%")
  }
  
  before_save :enforce_consistency_of_string_values
  
  def enforce_consistency_of_string_values
    self.subtype = nil if self.subtype.nil? || self.subtype.empty?
  end
  
  def has_card_image?
    !card_image_file_name.nil?
  end

  def has_card_back_image?
    !card_back_image_file_name.nil?
  end

  def has_vslip_image?
    !vslip_image_file_name.nil?
  end
  
  def has_vslip_back_image?
    !vslip_back_image_file_name.nil?
  end
  
  def is_virtual?
    expansion =~ /Virtual/
  end
  
  def is_flippable?
    card_type == "Objective"
  end

  def formatted_title
    "#{uniqueness}#{title}".html_safe
  end
  
  def card_type_and_subtype
    subtype.nil? ? card_type : "#{card_type} - #{subtype}"
  end

  def truncated_title(trunc_length)
    title.length > trunc_length ? "#{title.first(trunc_length)}..." : title
  end
  
  def self.expansions
    Card.all.map(&:expansion).uniq.sort
  end
  
  def self.uniquenesses
    Card.all.map(&:uniqueness).uniq.sort
  end
  
  def self.card_types
    Card.all.map(&:card_type).uniq.sort
  end
  
  def self.subtypes
    Card.all.map(&:subtype).map(&:to_s).uniq.sort
  end
  
  def self.subtypes_for(card_type)
    Card.all.select{ |c| c.card_type == card_type }.map(&:subtype).reject{ |i| i.nil? }.uniq.sort.insert(0,nil)
  end
  
  def self.card_characteristics_for(card_type)
    Card.all.select{ |c| c.card_type == card_type }.map(&:card_characteristics).flatten.uniq.sort{ |a,b|  a.name <=> b.name }
  end
  
  def self.card_attribute_names_for(card_type)
    Card.all.select{ |c| c.card_type == card_type }.map(&:card_attributes).flatten.map(&:name).uniq.sort
  end
  
  def method_missing(selector, *args)
    proper_selector = selector.to_s.capitalize
    super(selector, *args) unless CardAttribute.find_by_name(proper_selector)
    ca = card_attributes.select{ |ca| ca.name == proper_selector }.first
    ca.nil? ? nil : ca.value
  end
end
