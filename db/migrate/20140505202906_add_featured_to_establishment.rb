class AddFeaturedToEstablishment < ActiveRecord::Migration
  def change
    add_column :establishments, :featured, :boolean, :default => false
  end
end
