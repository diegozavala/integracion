class StockController < ApplicationController
	def index

	end

	def test
		request = RestClient.get 'http://example.com/resource', {:params => {:id => 50, 'foo' => 'bar'}}
	end

	def generate_auth_hash
		require 'openssl'
		require "base64"
		hash  = Base64.encode64(OpenSSL::HMAC.digest('sha1', STOCK_PRIVATE_KEY, "GET"))
		auth = 'UC '+STOCK_PUBLIC_KEY+':'+hash
	end
end