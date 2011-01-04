class CardlistItem < ActiveRecord::Base
  belongs_to :cardlist
  belongs_to :card
  
  validates :quantity, :presence => true
  validates :card_id, :presence => true
  validates :cardlist_id, :presence => true  
end
