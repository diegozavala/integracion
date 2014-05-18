class Producto < ActiveRecord::Base
   has_many :pedidos, through: :pedido_producto
end
