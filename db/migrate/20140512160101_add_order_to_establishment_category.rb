class AddOrderToEstablishmentCategory < ActiveRecord::Migration
  def change
    add_column :establishment_categories, :grouporder, :integer
  end
end
