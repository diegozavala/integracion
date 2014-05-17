class PedidoProducto < ActiveRecord::Base
  belongs_to :pedido
  belongs_to :producto
  self.table_name = "pedidos_productos"
end
