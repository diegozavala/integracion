class StockController < ApplicationController
	
	def index
	end

	#GET
	def almacenes
		@request = JSON.parse(RestClient.get Integra2::STOCK_API_URL+'almacenes', {:Authorization => generate_auth_hash('GET')})
	end

	def skus_with_stock
		@almacen = params[:almacen]
		@request = JSON.parse(RestClient.get Integra2::STOCK_API_URL+'skusWithStock', {:Authorization => generate_auth_hash('GET'+@almacen), :params=>{:almacenId=>@almacen}})
	end

	def sku
		@sku = params[:sku]
		@request = JSON.parse(RestClient.get Integra2::STOCK_API_URL+'stock', {:Authorization => generate_auth_hash('GET'+params[:almacen]+params[:sku]), :params=>{:almacenId=>params[:almacen], :sku=>params[:sku]}})
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