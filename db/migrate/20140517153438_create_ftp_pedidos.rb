class CreateFtpPedidos < ActiveRecord::Migration
  def change
    create_table :ftp_pedidos do |t|
      t.string :nombre_archivo
      t.integer :numero_pedido
      t.date :fecha_procesado

      t.timestamps
    end
  end
end
