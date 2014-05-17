module ApplicationHelper
	
	def get_almacenes
		@request = JSON.parse(RestClient.get Integra2::STOCK_API_URL+'almacenes', {:Authorization => generate_auth_hash('GET')})
	end

	def get_skus_with_stock(almacen)
		@request = JSON.parse(RestClient.get Integra2::STOCK_API_URL+'skusWithStock', {:Authorization => generate_auth_hash('GET'+almacen), :params=>{:almacenId=>almacen}})
	end

	def get_stock(almacen, sku, limit=nil)
		if limit == nil
			@request = JSON.parse(RestClient.get Integra2::STOCK_API_URL+'stock', {:Authorization => generate_auth_hash('GET'+almacen+sku), :params=>{:almacenId=>almacen, :sku=>sku}})
		else
			@request = JSON.parse(RestClient.get Integra2::STOCK_API_URL+'stock', {:Authorization => generate_auth_hash('GET'+almacen+sku), :params=>{:almacenId=>almacen, :sku=>sku, :limit=>limit}})
	end

	#metodos de la api por usar
	def mover_stock (producto, almacen)
		@request = JSON.parse(RestClient.get Integra2::STOCK_API_URL+'moveStock', {:Authorization => generate_auth_hash('POST'+producto+almacen), :params=>{:almacenId=>almacen, :productId=>producto}})
		#retorna Producto
	end 

	def mover_stock_bodega(producto, almacen)
		@request = JSON.parse(RestClient.get Integra2::STOCK_API_URL+'moveStockBodega', {:Authorization => generate_auth_hash('POST'+producto+almacen), :params=>{:almacenId=>almacen, :productId=>producto}})
		#retorna Producto
	end

	def despachar_stock(producto, direccion, precio, pedido)
		@request = JSON.parse(RestClient.get Integra2::STOCK_API_URL+'stock', {:Authorization => generate_auth_hash('DELETE'+producto+direccion+precio.to_s+pedido), :params=>{:productId=>producto, :direccion=>direccion, :precio=>precio, :pedidoId=>pedido}})
	end

	def generate_auth_hash(action)
		require 'openssl'
		require "base64"
		#funciona solo para test por ahora (por el GET)
		#codigo basado en http://jokecamp.wordpress.com/2012/10/21/examples-of-creating-base64-hashes-using-hmac-sha256-in-different-languages/#ruby
		hash  = Base64.encode64(OpenSSL::HMAC.digest('sha1', Integra2::STOCK_PRIVATE_KEY, action))
		auth = 'UC '+Integra2::STOCK_PUBLIC_KEY+':'+hash
	end
end
