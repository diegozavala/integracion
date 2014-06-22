class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :sku
      t.datetime :start
      t.datetime :end
      t.integer :price
      t.boolean :active

      t.timestamps
    end
  end
end
