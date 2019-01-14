class CreateEstablishmentCategories < ActiveRecord::Migration
  def change
    create_table :establishment_categories do |t|
      t.string :title

      t.timestamps
    end
  end
end
