class AddFechaDespachoToPedido < ActiveRecord::Migration
  def change
    add_column :pedidos, :fecha_despacho, :date
  end
end
