class RemoveTimestampsFromRolesUsersJoinTable < ActiveRecord::Migration
  def self.up
    remove_column :roles_users, :created_at
    remove_column :roles_users, :updated_at
  end

  def self.down
    change_table :roles_users do |t|
      t.timestamps
    end
  end
end
