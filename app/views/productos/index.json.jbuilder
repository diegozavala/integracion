json.array!(@productos) do |producto|
  json.extract! producto, :id, :sku
  json.url producto_url(producto, format: :json)
end
