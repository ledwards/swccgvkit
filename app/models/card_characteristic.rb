class CardCharacteristic < ActiveRecord::Base
  has_and_belongs_to_many :cards
  validates :name, :presence => true
end