class CreateEstablishments < ActiveRecord::Migration
  def change
    create_table :establishments do |t|
      t.string :name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.integer :zipcode
      t.string :phone
      t.string :website
      t.string :facebook_url
      t.string :twitter_url
      t.string :youtube_url
      t.string :logo_url
      t.text :description

      t.timestamps
    end
  end
end
