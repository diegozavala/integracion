class Pedido < ActiveRecord::Base
  has_many :pedido_producto
  has_many :productos, through: :pedido_producto
  
end
