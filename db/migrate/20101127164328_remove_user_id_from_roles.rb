class RemoveUserIdFromRoles < ActiveRecord::Migration
  def self.up
    remove_column :roles, :user_id
  end

  def self.down
    add_column :roles, :user_id, :integer
  end
end
