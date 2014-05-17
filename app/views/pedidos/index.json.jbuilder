json.array!(@pedidos) do |pedido|
  json.extract! pedido, :id, :fecha, :hora, :rut, :direccionId
  json.url pedido_url(pedido, format: :json)
end
