class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :establishment_id
      t.string :title
      t.text :description
      t.decimal :price

      t.timestamps
    end
  end
end
