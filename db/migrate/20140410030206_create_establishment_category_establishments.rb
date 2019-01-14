class CreateEstablishmentCategoryEstablishments < ActiveRecord::Migration
  def change
    create_table :establishment_category_establishments do |t|
      t.integer :establishment_id
      t.integer :establishment_category_id

      t.timestamps
    end
  end
end
