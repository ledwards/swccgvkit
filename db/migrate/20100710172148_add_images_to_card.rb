class AddImagesToCard < ActiveRecord::Migration
  def self.up
    add_column :cards, :card_image_file_name, :string
    add_column :cards, :card_image_content_type, :string
    add_column :cards, :card_image_file_size, :integer
    add_column :cards, :card_image_updated_at, :datetime
    
    add_column :cards, :vslip_image_file_name, :string
    add_column :cards, :vslip_image_content_type, :string
    add_column :cards, :vslip_image_file_size, :integer
    add_column :cards, :vslip_image_updated_at, :datetime
    
    add_column :cards, :card_back_image_file_name, :string
    add_column :cards, :card_back_image_content_type, :string
    add_column :cards, :card_back_image_file_size, :integer
    add_column :cards, :card_back_image_updated_at, :datetime
    
    add_column :cards, :vslip_back_image_file_name, :string
    add_column :cards, :vslip_back_image_content_type, :string
    add_column :cards, :vslip_back_image_file_size, :integer
    add_column :cards, :vslip_back_image_updated_at, :datetime
  end

  def self.down
    remove_column :cards, :card_image_file_name
    remove_column :cards, :card_image_content_type
    remove_column :cards, :card_image_file_size
    remove_column :cards, :card_image_updated_at
    
    remove_column :cards, :vslip_image_file_name
    remove_column :cards, :vslip_image_content_type
    remove_column :cards, :vslip_image_file_size
    remove_column :cards, :vslip_image_updated_at
    
    remove_column :cards, :card_back_image_file_name
    remove_column :cards, :card_back_image_content_type
    remove_column :cards, :card_back_image_file_size
    remove_column :cards, :card_back_image_updated_at
    
    remove_column :cards, :vslip_back_image_file_name
    remove_column :cards, :vslip_back_image_content_type
    remove_column :cards, :vslip_back_image_file_size
    remove_column :cards, :vslip_back_image_updated_at
  end
end
