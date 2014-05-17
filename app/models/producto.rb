class Producto < ActiveRecord::Base
   has_many_and_belongs_to :pedidos
end
