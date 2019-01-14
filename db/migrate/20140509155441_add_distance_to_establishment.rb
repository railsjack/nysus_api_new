class AddDistanceToEstablishment < ActiveRecord::Migration
  def change
    add_column :establishments, :distance, :float
  end
end
