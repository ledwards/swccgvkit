class CreateCardlists < ActiveRecord::Migration
  def self.up
    create_table :cardlists do |t|
      t.string :title
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :cardlists
  end
end
