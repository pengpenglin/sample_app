class AddEmailUniquenessIndex < ActiveRecord::Migration
  def self.up
    # Syntax: <method_name> table_name column_name, index_type
    add_index :users, :email, :unique => true 
  end

  def self.down
    remove_index :users,:email
  end
end
