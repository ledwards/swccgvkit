class CardlistItem < ActiveRecord::Base
  belongs_to :cardlist
  has_one :card
end
