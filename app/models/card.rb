class Card < ActiveRecord::Base
  validates_presence_of :title, :card_type, :expansion
end
