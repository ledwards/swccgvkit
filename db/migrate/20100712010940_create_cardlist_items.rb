class CreateCardlistItems < ActiveRecord::Migration
  def self.up
    create_table :cardlist_items do |t|
      t.references :cardlist
      t.references :card
      t.integer :quantity
    end
  end

  def self.down
    drop_table :cardlist_items
  end
end
