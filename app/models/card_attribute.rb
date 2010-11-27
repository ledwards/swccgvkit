class CardAttribute < ActiveRecord::Base
  belongs_to :card
  validates :name, :presence => true
  validates :value, :presence => true
end
