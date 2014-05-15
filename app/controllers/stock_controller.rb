class StockController < ApplicationController
	
	def index
	end

	#GET
	def almacenes
		api_request('almacenes', 'GET')
	end

	def skus_with_stock
		api_request('skusWithStock', 'GET')
	end

	def sku
		api_request('stock', 'GET')
	end

	def generate_auth_hash(action)
		require 'openssl'
		require "base64"
		#funciona solo para test por ahora (por el GET)
		#codigo basado en http://jokecamp.wordpress.com/2012/10/21/examples-of-creating-base64-hashes-using-hmac-sha256-in-different-languages/#ruby
		hash  = Base64.encode64(OpenSSL::HMAC.digest('sha1', Integra2::STOCK_PRIVATE_KEY, action))
		auth = 'UC '+Integra2::STOCK_PUBLIC_KEY+':'+hash
		end

	private
		def api_request(url, action)
			@request = JSON.parse(RestClient.get Integra2::STOCK_API_URL+url, {:Authorization => generate_auth_hash(action)})
		end
end