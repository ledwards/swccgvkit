class Card < ActiveRecord::Base
  validates_presence_of :title, :card_type, :expansion
  
  has_and_belongs_to_many :card_characteristics
  has_many :card_attributes
  
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

end
