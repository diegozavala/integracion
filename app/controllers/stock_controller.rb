class StockController < ApplicationController
	
	def index
	end

	def almacenes
		@request = AplicationHelper::get_almacenes
	end

	def almacen
		@almacen = params[:almacen]
		@skus_with_stock = AplicationHelper::get_skus_with_stock(@almacen)
	end

	def products
		@sku = params[:sku]
		@request = AplicationHelper::get_stock(params[:almacen],@sku)
	end
end