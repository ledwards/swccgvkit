class Cardlist < ActiveRecord::Base
  has_many :cardlist_items, :dependent => :destroy
  belongs_to :user
  
  before_create :set_default_title
  
  validates :user_id, :presence => true
  
  def card_count
    count = 0
    self.cardlist_items.each { |cli| count += cli.quantity } if self.cardlist_items.any?
    count
  end
  
  def add_card(card)
    cardlist_item = self.cardlist_items.select{ |cli| cli.card.id == card.id }.first || self.cardlist_items.find_by_card_id(card.id) || self.cardlist_items.build

    if cardlist_item.new_record?
      cardlist_item.update_attributes({ :quantity => 1, :card_id => card.id })
    else
      cardlist_item.update_attribute(:quantity, cardlist_item.quantity + 1)
    end
  end
  
  protected
  
  def set_default_title
    self.title ||= "Unnamed Cardlist"
  end
end
