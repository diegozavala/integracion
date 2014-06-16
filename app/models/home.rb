
class Home < ActiveRecord::Base
  include ApplicationHelper


  def self.test_ftp 
    error =0
    linea = []
    
    require 'google_drive'
    session=GoogleDrive.login("integradosuc@gmail.com", "clavesecreta")
    file= session.spreadsheet_by_key('0As9H3pQDLg79dDJzZkU1TldhQmg5MXdDZFM5R1RCQXc').worksheets[0]
    num_row=file.num_rows-4

    values=[]
    
    
    num_row.times do |j|
      linea[j] = []
      linea[j][1] = file[j+4,1]
      linea[j][2] = file[j+4,2]
      linea[j][3] = file[j+4,3]
      linea[j][4] = file[j+4,4]
    end
    
    
    require 'net/sftp' 
   
    sftp2=Net::SFTP
    sftp2.start('integra.ing.puc.cl','grupo2', :password => 'apijd9292') do |sftp|
      
      cont=0
      sftp.dir.foreach("/home/grupo2/Pedidos") do |entry|
        if entry.name.downcase.include? ".xml"
          num_pedido = entry.name[entry.name.index('_')+1..entry.name.index('.')-1]
          
          
          FtpPedido.find_or_create_by(nombre_archivo: entry.name, numero_pedido: num_pedido ) do |c|
            #bajo el contenido del archivo y lo guardo en contenido
            c.contenido = sftp.download!("/home/grupo2/Pedidos/"+entry.name)
            c.save!
              
            # leer el pedido y crear los objetos
            doc = Nokogiri::XML(c.contenido)
            root = doc.root
            ped = doc.at_xpath("/*/Pedidos")
            fecha = ped["fecha"]
            hora = ped["hora"]
            rut = doc.at_xpath("/*/Pedidos/rut").text
            dirId = doc.at_xpath("/*/Pedidos/direccionId").text
            fecha_despacho = doc.at_xpath("/*/Pedidos/fecha").text
            
            #averiguar direccion del cliente
            direccion = get_shipto(dirId)
      
            pedido = Pedido.create(:fecha => fecha, :hora => hora, :rut => rut, :direccionId => dirId )
      
            hay_stock = []
            
            pedi = doc.xpath("//Pedido")
            i=0
            #para cada elemento del pedido, vemos si hay stock reservado, normal, en otroas bodegas (se despacha en todo lo anterior), o se quiebra
            pedi.each do |p|
              puts "adelante"
              sku = p.xpath("sku").text
    
              cant = p.xpath("cantidad").text
              un = p.at_xpath("cantidad")["unidad"]
              prod = Producto.find_or_create_by(sku: sku)
             
              pp = PedidoProducto.create(:pedido_id => pedido.id, :producto_id => prod.id, :cantidad => cant , :unidad => un)
              
              hay_stock[i] = 0 #0 no hay, 1 privilegiado, 2 bodega
              
              #vemos stocks privilegiados
              num_row.times do |j|
                if(linea[j][1]==rut and linea[j][2]==sku and (linea[j][3]-linea[j][4])>cant) 
                  puts "Hay stock en reserva"
                  hay_stock[i] = 1
                  write_data_gdoc(j+4,linea[j][4]-cant)
                  
                  despachar(sku,cant.to_i, direccion, num_pedido)
                  registro_dw
                  
                  break
                end
              end
              sku=sku.delete(' ')
              
              
              sto = JSON.parse(get_stock('53571c4f682f95b80b7563e6', sku.to_s))
              stock_disp = sto.length
              
              
              if( hay_stock[i] == 0 and stock_disp>cant.to_i)
                puts "Hay stock en bodega"
                hay_stock[i] = 2
                
                despachar(sku,cant.to_i, direccion, num_pedido)
                registro_dw
                
              elsif (hay_stock[i] == 0 )
                #pedir apis!
                
                #si hay, se despacha,y registro en dw
                #si no hay en otras bodegas, informar quiebre a dw
                
              end
              i+=1
            end
          end 
          cont+=1
        end      
      end
    end     
  end
    
    
  def despachar(sku, cantidad, direccion, num_pedido)
    sku = sku.to_s.delete(' ')
    precio = get_price_with_sku(sku)
    
    sto = JSON.parse(get_stock('53571c4f682f95b80b7563e6', sku.to_s, cantidad))
    
    cantidad.times do |j|    
      mover_stock(sto[j]["_id"].to_s, '53571c4f682f95b80b7563e5')
      despachar_stock(sto[j]["_id"], direccion, precio, num_pedido)
    end
  
  end
  
  def registro_dw
    #desarrollar!!
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


  def send_tweet(message)
    require 'twitter'

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "VMskMaBDtwH11TFXvVlnrGdSr"
      config.consumer_secret     = "lILUxZ3rFEs6FamFUiRN6NISeGOTCGNuKP6w7h1Z3tg2YsyVK9"
      config.access_token        = "2567568456-ojoAMV8ui23FGYkXvFU6TTj4NLbhprZMQQ1u5v4"
      config.access_token_secret = "nefBA9qDiKcphnIfsiZqcaYzcBzTMxsAnLs3zHCLN987M"
    end

    client.update(message)
    # message debe ser producto, duracion de oferta, precio y un link. Esto cada vez que se reciba un mensaje
  end
end


  


