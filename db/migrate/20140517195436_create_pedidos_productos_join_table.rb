class CreatePedidosProductosJoinTable < ActiveRecord::Migration
  def change
    create_table :pedidos_productos, id: false do |t|
          t.integer :pedido_id
          t.integer :producto_id
          t.integer :sku
        end
      end
end
