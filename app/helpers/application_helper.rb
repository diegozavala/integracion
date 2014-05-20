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
	end

	#metodos de la api por usar
	def mover_stock (producto, almacen)
		r = HTTParty.post(Integra2::STOCK_API_URL+'moveStock',
		{ 
		:body => {"productoId" => producto, "almacenId" => almacen},
		:headers => {'Authorization' => generate_auth_hash('POST'+producto+almacen)}
		})
		#retorna Producto
	end 

	def mover_stock_bodega(producto, almacen)
		r = HTTParty.post(Integra2::STOCK_API_URL+'moveStockBodega',
		{ 
		:body => {"productoId" => producto, "almacenId" => almacen},
		:headers => {'Authorization' => generate_auth_hash('POST'+producto+almacen)}
		})
		#retorna Producto
	end
	############################ MIRA ESTA WEA TOY ####################################
	### 	aca lo estoy haciendo Toy, cambia las weas q te parescan pertinentes 	###
	###		No se como manejar lo del almacen..hay q revisar todos los almacenes?? 	###
	###		le puse almacen_nuestro...pero eso no va a funcar						###
	###################################################################################

	def mover_stock_bodega_fuera(sku, almacen, cantidad)
		if(cantidad < get_stock(almacen_nuestro, sku, limit=nil))
			for i in 1..cantidad
				r = HTTParty.post(Integra2::STOCK_API_URL+'moveStockBodega',
				{ 
				:body => {"productoId" => producto, "almacenId" => almacen},
				:headers => {'Authorization' => generate_auth_hash('POST'+producto+almacen)}
				})
			end
		end
		#retorna Producto
	end



	def despachar_stock(producto, direccion, precio, pedido)
		@request = JSON.parse(RestClient.delete Integra2::STOCK_API_URL+'stock', {:Authorization => generate_auth_hash('DELETE'+producto+direccion+precio.to_s+pedido), :params=>{:productoId=>producto, :direccion=>direccion, :precio=>precio, :pedidoId=>pedido}})
	end

	def generate_auth_hash(action)
		require 'openssl'
		require "base64"
		#funciona solo para test por ahora (por el GET)
		#codigo basado en http://jokecamp.wordpress.com/2012/10/21/examples-of-creating-base64-hashes-using-hmac-sha256-in-different-languages/#ruby
		hash  = Base64.encode64(OpenSSL::HMAC.digest('sha1', Integra2::STOCK_PRIVATE_KEY, action))
		auth = 'UC '+Integra2::STOCK_PUBLIC_KEY+':'+hash
	end

	def get_shipto(direccionID)
		user_name = 'grupo2' 
	    url1 = 'http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation=getchallenge'
	    url2 = 'http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation=login'
	    @token = ActiveSupport::JSON.decode(Net::HTTP.get_response(URI.parse(url1+'&username=grupo2')).body)['result']['token'] 
	    @key =@token+'jxrjMwjnG0ndVpC'
	    @md5 = Digest::MD5.hexdigest(@key) 
	    @response = JSON.parse((HTTParty.post url2, :body => { 'operation' => 'login', 'username' => user_name, 'accessKey' => @md5 }).response.body) 
	    @sessionid=@response['result']['sessionName']

	    @clientes=ActiveSupport::JSON.decode(Net::HTTP.get_response(URI.parse('http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation=query&sessionName='+@sessionid+'&query='+URI.encode('select * from Contacts limit 0,100;'))).body)['result']
	    (1..15).each do |i|
	      @auxiliar=ActiveSupport::JSON.decode(Net::HTTP.get_response(URI.parse('http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation=query&sessionName='+@sessionid+'&query='+URI.encode('select * from Contacts limit '+(i*100+1).to_s+','+((i+1)*100).to_s+';'))).body)['result']
	      @auxiliar.each do |aux|
	        @clientes << aux
	      end
	    end

		return @clientes.find{|instancia| instancia['cf_707'] = direccionID}['otherstreet']

	end
	def get_companyname(rut)
		user_name = 'grupo2' 
	    url1 = 'http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation=getchallenge'
	    url2 = 'http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation=login'
	    @token = ActiveSupport::JSON.decode(Net::HTTP.get_response(URI.parse(url1+'&username=grupo2')).body)['result']['token'] 
	    @key =@token+'jxrjMwjnG0ndVpC'
	    @md5 = Digest::MD5.hexdigest(@key) 
	    @response = JSON.parse((HTTParty.post url2, :body => { 'operation' => 'login', 'username' => user_name, 'accessKey' => @md5 }).response.body) 
	    @sessionid=@response['result']['sessionName']

	    @accounts=ActiveSupport::JSON.decode(Net::HTTP.get_response(URI.parse('http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation=query&sessionName='+@sessionid+'&query='+URI.encode('select * from Accounts limit 0,100;'))).body)['result']
	    (1..15).each do |i|
	      @auxiliar=ActiveSupport::JSON.decode(Net::HTTP.get_response(URI.parse('http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation=query&sessionName='+@sessionid+'&query='+URI.encode('select * from Accounts limit '+(i*100+1).to_s+','+((i+1)*100).to_s+';'))).body)['result']
	      @auxiliar.each do |aux|
	        @accounts << aux
	      end
	    end

		return @accounts.find{|instancia| instancia['cf_705'] = direccionID}['accountname']

	end
	def get_row_gdoc i
		require 'google_drive'
		session=GoogleDrive.login("integradosuc@gmail.com", "clavesecreta")
		file= session.spreadsheet_by_key('0As9H3pQDLg79dDJzZkU1TldhQmg5MXdDZFM5R1RCQXc').worksheets[0]

		values=[]
		values << file[i,1]
		values << file[i,2]
		values << file[i,3]
		values << file[i,4]

		return values
	end
	def get_date_gdoc
		require 'google_drive'

		session=GoogleDrive.login("integradosuc@gmail.com", "clavesecreta")
		file= session.spreadsheet_by_key('0As9H3pQDLg79dDJzZkU1TldhQmg5MXdDZFM5R1RCQXc').worksheets[0]
		return file[2,2]
	end
	def get_num_rows_gdoc
		require 'google_drive'

		session=GoogleDrive.login("integradosuc@gmail.com", "clavesecreta")
		file= session.spreadsheet_by_key('0As9H3pQDLg79dDJzZkU1TldhQmg5MXdDZFM5R1RCQXc').worksheets[0]

		return file.num_rows - 4
	end
	def write_data_gdoc row, text
		require 'google_drive'

		session=GoogleDrive.login("integradosuc@gmail.com", "clavesecreta")
		file= session.spreadsheet_by_key('0As9H3pQDLg79dDJzZkU1TldhQmg5MXdDZFM5R1RCQXc').worksheets[0]
		file[row,4] = text
		file.save()
	end

end
