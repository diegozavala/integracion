class StockController < ApplicationController

	include ApplicationHelper

	def index
	end

	def almacenes
		#test = generate_auth_hash('POST53571c4f682f95b80b75645b53571c4f682f95b80b7563e6')
		#sku = 3871447
		#test mover producto
		#test = mover_stock('53571c4f682f95b80b75645b','53571c4f682f95b80b7563e6')
		#puts 'TEST PRODUCTOS'
		#puts test
		@request = get_almacenes
	end

	def almacen
		@almacen = params[:almacen]
		@skus_with_stock = get_skus_with_stock(@almacen)
	end

	def products
		@sku = params[:sku]
		@request = get_stock(params[:almacen],@sku)
	end
end