class CreateAdminUsers < ActiveRecord::Migration

  def self.up
    create_table :admin_users do |t|
      t.string :first_name, :default => "", :null => false
      t.string :last_name, :default => "", :null => false
      t.string :role, :null => false
      t.string :email, :null => false
      t.boolean :status, :default => false
      t.string :token, :null => false
      t.string :password_digest, :null => false
      t.string :preferences
      t.timestamps
    end
    add_index :admin_users, :email, :unique => true
  end

  def self.down
    drop_table :admin_users
  end

end
