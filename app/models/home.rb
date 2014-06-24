class Home < ActiveRecord::Base
  def self.vaciar_recepcion
    require 'json'
    puts "Vaciando recepcion..."
    skus_recepcion = JSON.parse(get_skus_with_stock(Integra2::ALMACEN_RECEPCION))
    puts skus_recepcion.to_s
    skus_recepcion.each do |sku|
      mover_stock_cantidad(sku["_id"],'53571c4f682f95b80b7563e6',sku["total"],'recepcion')
      puts 'A total of '+sku["total"].to_s+' products sku: '+sku["id"].to_s+' where moved'
    end
  end

  def self.get_skus_with_stock(almacen)
    @request = RestClient.get Integra2::STOCK_API_URL+'skusWithStock', {:Authorization => generate_auth_hash('GET'+almacen), :params=>{:almacenId=>almacen}}
  end

  def self.generate_auth_hash(action)
    require 'openssl'
    require "base64"
    #funciona solo para test por ahora (por el GET)
    #codigo basado en http://jokecamp.wordpress.com/2012/10/21/examples-of-creating-base64-hashes-using-hmac-sha256-in-different-languages/#ruby
    hash  = Base64.encode64(OpenSSL::HMAC.digest('sha1', Integra2::STOCK_PRIVATE_KEY, action))
    auth = 'UC '+Integra2::STOCK_PUBLIC_KEY+':'+hash
  end


  def self.mover_stock_cantidad(sku,almacen_dest,cantidad,modo=nil)
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

  def self.get_stock(almacen, sku, limit=nil)
    if limit == nil
      RestClient.get Integra2::STOCK_API_URL+'stock', {:Authorization => generate_auth_hash('GET'+almacen+sku), :params=>{:almacenId=>almacen, :sku=>sku}}
    else
      RestClient.get Integra2::STOCK_API_URL+'stock', {:Authorization => generate_auth_hash('GET'+almacen+sku), :params=>{:almacenId=>almacen, :sku=>sku, :limit=>limit}}
    end
  end

  #metodos de la api por usar
  def self.mover_stock (producto, almacen)
    r = HTTParty.post(Integra2::STOCK_API_URL+'moveStock',
    {
    :body => {"productoId" => producto, "almacenId" => almacen},
    :headers => {'Authorization' => generate_auth_hash('POST'+producto+almacen)}
    })
    #retorna Producto
  end

  def self.mover_stock_bodega(producto, almacen)
    r = HTTParty.post(Integra2::STOCK_API_URL+'moveStockBodega',
    {
      :body => {"productoId" => producto, "almacenId" => almacen},
      :headers => {'Authorization' => generate_auth_hash('POST'+producto+almacen)}
    })
    #retorna Producto
  end



  def self.get_reposicion
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


  def self.test_dropbox
    # Install this the SDK with "gem install dropbox-sdk"
    require 'dropbox_sdk'
# Get your app key and secret from the Dropbox developer website


    flow = DropboxOAuth2FlowNoRedirect.new('wb82ws1fikrhwyg', '1u3v87temqiceoc')
    authorize_url = flow.start()

# Have the user sign in and authorize this app
# puts '1. Go to: ' + authorize_url
# puts '2. Click "Allow" (you might have to log in first)'
# puts '3. Copy the authorization code'
# print 'Enter the authorization code here: '

# This will fail if the user gave us an invalid authorization code
    access_token, user_id = '8HFipp0Yd3UAAAAAAAAA8GC3R6wlN99qsXuK7RDoPtXeowWRGmCSwiwwBc3lH1mH'

    client = DropboxClient.new(access_token)
    puts "linked account:", client.account_info().inspect

# file = open('working-draft.txt')
# response = client.put_file('/magnum-opus.txt', file)
# puts "uploaded:", response.inspect
    root_metadata = client.metadata('/')
    puts "metadata:", root_metadata.inspect

    contents, metadata = client.get_file_and_metadata('/Grupo2/DBPrecios.accdb')
    open('DBPrecios.accdb', 'wb') {|f| f.puts contents }

# File.open('DBPrecios.accdb', 'rb') do |file|
#  print file.readline()
#  end
#database = Mdb.open 'DBPrecios.mdb'
#puts "TABLAS: "
#puts database.tables.to_s
#database[database.tables[0].to_s]
    system( "java -jar access2csv.jar DBPrecios.accdb" )

  end



end


  


