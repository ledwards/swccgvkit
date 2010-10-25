class CreateCardAttributes < ActiveRecord::Migration
  def self.up
    create_table :card_attributes do |t|
      t.string :name
      t.integer :value
      t.references :card
    end
  end

  def self.down
    drop_table :card_attributes
  end
end
