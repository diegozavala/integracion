class StockController < ApplicationController
	
	include ApplicationHelper

	def index
	end

	def almacenes
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