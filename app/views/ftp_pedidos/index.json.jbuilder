json.array!(@ftp_pedidos) do |ftp_pedido|
  json.extract! ftp_pedido, :id, :nombre_archivo, :numero_pedido, :fecha_procesado
  json.url ftp_pedido_url(ftp_pedido, format: :json)
end
