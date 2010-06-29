class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.string :title
      t.string :side
      t.string :lore
      t.string :gametext
      t.string :rarity
      t.string :uniqueness
      
      t.string :card_type
      t.string :subtype
      t.string :expansion

      t.timestamps
    end
  end

  def self.down
    drop_table :cards
  end
end
