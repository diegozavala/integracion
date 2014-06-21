json.array!(@offers) do |offer|
  json.extract! offer, :id, :sku, :start, :end, :price, :active
  json.url offer_url(offer, format: :json)
end
