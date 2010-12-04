class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :card_attributes, :card_id
    add_index :card_characteristics_cards, :card_id
    add_index :card_characteristics_cards, :card_characteristic_id
    add_index :roles_users, :role_id
    add_index :roles_users, :user_id
  end

  def self.down
    remove_index :card_attributes, :card_id
    remove_index :card_characteristics_cards, :card_id
    remove_index :card_characteristics_cards, :card_characteristic_id
    remove_index :roles_users, :role_id
    remove_index :roles_users, :user_id
  end
end
