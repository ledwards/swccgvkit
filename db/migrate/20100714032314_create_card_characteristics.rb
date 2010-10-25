class CreateCardCharacteristics < ActiveRecord::Migration
  def self.up
    create_table :card_characteristics do |t|
      t.string :name
    end
    
    create_table :card_characteristics_cards, :id => false do |t|
      t.references :card
      t.references :card_characteristic
    end
  end

  def self.down
    drop_table :card_characteristics
    drop_table :card_characteristics_cards
  end
end
