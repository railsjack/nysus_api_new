class CreateSpecials < ActiveRecord::Migration
  def change
    create_table :specials do |t|
      t.string :title
      t.datetime :start_time
      t.datetime :end_time
      t.text :description
      t.integer :establishment_id

      t.timestamps
    end
  end
end
