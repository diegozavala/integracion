Spree::Product.class_eval do
  has_many :pedidos, through: :pedido_producto
end
