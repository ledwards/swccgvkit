class AddLegacyToCards < ActiveRecord::Migration
  def self.up
    add_column :cards, :legacy, :boolean, :null => false, :default => false
    add_index :cards, :legacy
    Card.virtual.each do |card|
      card.update_attribute(:legacy, true)
    end
  end

  def self.down
    remove_index :cards, :column => :legacy
    remove_column :cards, :legacy
  end
end
