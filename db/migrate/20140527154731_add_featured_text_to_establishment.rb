class AddFeaturedTextToEstablishment < ActiveRecord::Migration
  def change
    add_column :establishments, :featured_text, :text
  end
end
