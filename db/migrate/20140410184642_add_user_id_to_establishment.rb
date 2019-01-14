class AddUserIdToEstablishment < ActiveRecord::Migration
  def change
    add_column :establishments, :user_id, :integer
  end
end
