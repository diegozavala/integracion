module ApplicationHelper 

  def get_price_with_sku(sku)
    CSV.foreach("Pricing.csv") do |row|
      if row[1].to_i == sku.to_i
        return row[2].to_s
        break
      end
    end
  end

  def get_almacenes
		@request = RestClient.get Integra2::STOCK_API_URL+'almacenes', {:Authorization => generate_auth_hash('GET')}
	end

	def get_skus_with_stock(almacen)
		@request = RestClient.get Integra2::STOCK_API_URL+'skusWithStock', {:Authorization => generate_auth_hash('GET'+almacen), :params=>{:almacenId=>almacen}}
	end

	def get_stock(almacen, sku, limit=nil)
		if limit == nil
			RestClient.get Integra2::STOCK_API_URL+'stock', {:Authorization => generate_auth_hash('GET'+almacen+sku), :params=>{:almacenId=>almacen, :sku=>sku}}
		else
			RestClient.get Integra2::STOCK_API_URL+'stock', {:Authorization => generate_auth_hash('GET'+almacen+sku), :params=>{:almacenId=>almacen, :sku=>sku, :limit=>limit}}
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

  #METODOS PARA VACIAR ALMACENES DE RECEPCION Y PULMON

  def vaciar
    vaciar_pulmon
    vaciar_recepcion
  end

  def vaciar_pulmon
    puts "Vaciando pulmon..."
    skus_pulmon = JSON.parse(get_skus_with_stock(Integra2::ALMACEN_PULMON))
    puts skus_pulmon.to_s
    skus_pulmon.each do |sku|
      mover_stock_cantidad(sku["_id"],'53571c4f682f95b80b7563e6',sku["total"],'pulmon')
      puts 'A total of '+sku["total"].to_s+' products sku: '+sku["id"].to_s+' where moved'
    end
  end

  def vaciar_recepcion
    puts "Vaciando recepcion..."
    skus_recepcion = JSON.parse(get_skus_with_stock(Integra2::ALMACEN_RECEPCION))
    puts skus_recepcion.to_s
    skus_recepcion.each do |sku|
      mover_stock_cantidad(sku["_id"],'53571c4f682f95b80b7563e6',sku["total"],'recepcion')
      puts 'A total of '+sku["total"].to_s+' products sku: '+sku["id"].to_s+' where moved'
    end
  end


	def mover_stock_cantidad(sku,almacen_dest,cantidad,modo=nil)
		if modo == 'recepcion'
      productos = JSON.parse(get_stock(Integra2::ALMACEN_RECEPCION,sku,cantidad))
    elsif modo == 'pulmon'
      productos = JSON.parse(get_stock(Integra2::ALMACEN_PULMON,sku,cantidad))
    else
      productos = JSON.parse(get_stock('53571c4f682f95b80b7563e6',sku,cantidad))
    end
		# productos_a_despachar = productos.take(a_despachar)
		#RESTAR reservas
		if productos.length<cantidad.to_i
			return JSON.parse({error: 'No hay stock para la cantidad solicitada'}.to_json)
		end
		productos.each do |p|
      if modo == 'api'
        response = mover_stock(p["_id"],Integra2::ALMACEN_DESPACHO)
			  response = mover_stock_bodega(p["_id"],almacen_dest)
      else
        response = mover_stock(p["_id"],almacen_dest)
      end
      puts response
			if response["error"]
				return response
			end
		end
		return JSON.parse({'SKU' => sku.to_s, cantidad: cantidad.to_s}.to_json)
	end

	def despachar_stock(producto, direccion, precio, pedido)
		#@request = JSON.parse(RestClient.delete Integra2::STOCK_API_URL+'stock', {:Authorization => generate_auth_hash('DELETE'+producto+direccion+precio.to_s+pedido), :params=>{:productoId=>producto, :direccion=>direccion, :precio=>precio, :pedidoId=>pedido}})
		r = HTTParty.delete(Integra2::STOCK_API_URL+'stock',
		{ 
		:body => {"productoId" => producto, "direccion" => direccion, "precio" => precio, "pedidoId"=> pedido},
		:headers => {'Authorization' => generate_auth_hash('DELETE'+producto.to_s+direccion+precio.to_s+pedido.to_s)}
		})
		puts "Stock despachado => "+r.to_s
		#retorna Producto
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

		return @clientes.find{|instancia| instancia['cf_707'] == direccionID.to_s}['otherstreet']
	end

	def get_clientname(direccionID)
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
	    nombre = @clientes.find{|instancia| instancia['cf_707'] == direccionID.to_s}['firstname']
	    apellido = @clientes.find{|instancia| instancia['cf_707'] == direccionID.to_s}['lastname']
	    nombreyapellido = nombre.to_s+ ' '+apellido.to_s
		return nombreyapellido
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

		return rut

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


  def get_offers
    require "bunny" # don't forget to put gem "bunny" in your Gemfile

    b = Bunny.new('amqp://ukrtynvc:AXr6Up0yW2OEs7UdxRQyLbD11RvYwm4x@hyena.rmq.cloudamqp.com/ukrtynvc')
    b.start # start a communication session with the amqp server

    q = b.queue("ofertas",:auto_delete => true) # declare a queue

# declare default direct exchange which is bound to all queues
    e = b.exchange("")

    list = []
    msg = q.pop # get message from the queue
    while msg.last.to_s != ""
      list.append(msg.last)
      msg = q.pop
    end

    b.stop # close the connection

  end

  def send_tweet_offer(msg)

    require 'json'

    hash = JSON[msg]
    sku = hash["sku"]
    precio = hash["precio"]
    inicio = hash["inicio"]
    fin = hash["fin"]
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "VMskMaBDtwH11TFXvVlnrGdSr"
      config.consumer_secret     = "lILUxZ3rFEs6FamFUiRN6NISeGOTCGNuKP6w7h1Z3tg2YsyVK9"
      config.access_token        = "2567568456-ojoAMV8ui23FGYkXvFU6TTj4NLbhprZMQQ1u5v4"
      config.access_token_secret = "nefBA9qDiKcphnIfsiZqcaYzcBzTMxsAnLs3zHCLN987M"
    end

#Ademas actualizar en caso de que sean ofertas
    client.update("OFERTA! El producto "+sku.to_s+" a solo $"+precio.to_s+" desde "+inicio.to_s+" hasta el "+fin.to_s)
      # message debe ser producto, duracion de oferta, precio y un link. Esto cada vez que se reciba un mensaje



  end

  def get_reposicion
    require "bunny" # don't forget to put gem "bunny" in your Gemfile

    b = Bunny.new('amqp://ukrtynvc:AXr6Up0yW2OEs7UdxRQyLbD11RvYwm4x@hyena.rmq.cloudamqp.com/ukrtynvc')
    b.start # start a communication session with the amqp server

    q = b.queue("reposicion",:auto_delete => true) # declare a queue

# declare default direct exchange which is bound to all queues
    e = b.exchange("")

    list = []
    msg = q.pop # get message from the queue
    while msg.last.to_s != ""
      list.append(msg.last.to_s)
      msg = q.pop
    end
    puts "This is the message: " + msg.last.to_s + "\n\n"

    b.stop # close the connection

    vaciar_recepcion # el almacen de recepcion!
  end

end