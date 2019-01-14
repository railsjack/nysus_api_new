class AddSortOrderToEstablishmentCategory < ActiveRecord::Migration
  def change
    add_column :establishment_categories, :sort_order, :integer
  end
end
