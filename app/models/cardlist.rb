class Cardlist < ActiveRecord::Base
  has_many :cardlist_items
  belongs_to :user
  
  def total_quantity
    return 5 #placeholder
  end
end
