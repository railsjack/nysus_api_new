class CreateEstablishmentCategoriesEstablishments < ActiveRecord::Migration
  def change
    create_table :establishment_categories_establishments do |t|
      t.integer :establishment_id
      t.integer :establishment_category_id

      t.timestamps
    end
  end
end
