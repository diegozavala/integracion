class Pedido < ActiveRecord::Base
  has_many_and_belongs_to :partidos
end
