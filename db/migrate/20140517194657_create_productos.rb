class CreateProductos < ActiveRecord::Migration
  def change
    create_table :productos do |t|
      t.integer :sku

      t.timestamps
    end
  end
end
