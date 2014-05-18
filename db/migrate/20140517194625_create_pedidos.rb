class CreatePedidos < ActiveRecord::Migration
  def change
    create_table :pedidos do |t|
      t.date :fecha
      t.time :hora
      t.text :rut
      t.integer :direccionId

      t.timestamps
    end
  end
end
