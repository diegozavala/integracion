class Pedido < ActiveRecord::Base
  has_many :productos, through: :pedido_producto
end
