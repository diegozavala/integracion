class AddContenidoToFtpPedidos < ActiveRecord::Migration
  def change
    add_column :ftp_pedidos, :contenido, :text
  end
end
