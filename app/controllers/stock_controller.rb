class StockController < ApplicationController
	protect_from_forgery with: :null_session


	include ApplicationHelper

	##PARA TESTING
	## PRODUCT ID: 53571c4f682f95b80b75645b

	def index
	end

	def post
		action = params["action"]
		if(action = 'mover_stock')
			mover_stock(params["ID Producto"],params["ID Almacen"])
		elsif(action = 'mover_stock_bodega')
			mover_stock_bodega(params["ID Producto"],params["ID Almacen"])
		elsif(action = 'despachar_stock')
			despachar_stock(params["ID Producto"],params["Direccion"],params["Precio"],params["Id Pedido"])
		else puts "Accion no válida"
		end
		redirect_to stock_almacenes_path
	end
	
	def almacenes
		#test = generate_auth_hash('POST53571c4f682f95b80b75645b53571c4f682f95b80b7563e6')
		#sku = 3871447
		#test mover producto
		#test = mover_stock('53571c4f682f95b80b75645b','53571c4f682f95b80b7563e6')
		#puts 'TEST PRODUCTOS'
		#puts test
		@request = JSON.parse(get_almacenes)
	end

	def almacen
		@almacen = params[:almacen]
		@skus_with_stock = JSON.parse(get_skus_with_stock(@almacen))
	end

	def products
		@sku = params[:sku]
		@request = JSON.parse(get_stock(params[:almacen],@sku))
	end
end