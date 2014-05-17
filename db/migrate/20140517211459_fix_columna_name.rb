class FixColumnaName < ActiveRecord::Migration
  def change
    rename_column :pedidos_productos, :sku, :cantidad
    add_column :pedidos_productos, :unidad, :text
  end
end
