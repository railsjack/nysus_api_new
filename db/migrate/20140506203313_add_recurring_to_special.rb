class AddRecurringToSpecial < ActiveRecord::Migration
  def change
    add_column :specials, :recurring, :string
  end
end
