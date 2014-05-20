
class Home < ActiveRecord::Base
  include ApplicationHelper


  def test_ftp 
    
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
      
            pedido = Pedido.create(:fecha => fecha, :hora => hora, :rut => rut, :direccionId => dirId )
      
            hay_stock = []
            pedi = doc.xpath("//Pedido")
            pedi.each do |p|
              i=0
              sku = p.xpath("sku").text
    
              cant = p.xpath("cantidad").text
              un = p.at_xpath("cantidad")["unidad"]
              prod = Producto.find_or_create_by(sku: sku)
              #prod = Spree::Product.where(:sku => sku)["id"]
              pp = PedidoProducto.create(:pedido_id => pedido.id, :producto_id => prod.id, :cantidad => cant , :unidad => un)
              
              hay_stock[i] = 0
              #vemos stocks privilegiados
              
              num_row.times do |j|
                #linea=get_row_gdoc(j+4)
                if(linea[j][1]==rut and linea[j][2]==sku and (linea[j][3]-linea[j][4])>cant) 
                  hay_stock[i] = 1
                  write_data_gdoc(j+4,linea[j][4]-cant)
                  break
                end
              end
              
              sto = get_stock("53571c4f682f95b80b7563e6", sku)

              if( hay_stock[i] == 0 and sto.count>cant.to_i)
                hay_stock[i] = 2
              end
              i+=1
            end
            
            
            
            pedido.productos.each do |c|
              #si es que no hay stock..
              if hay_stock.find(0)
                #informar quiebre de pedido a dw. ¿Se mandan los productos que si estan???
                
                #si hay stock  
              else
              
                #averiguar direccion del cliente
                direccion = get_shipto(dirId)
                pedido.productos.each do |c|
                  #pasar stock a despacho
                  c.cantidad.times do
                    mover_stock_bodega(c.sku, "53571c4f682f95b80b7563e5")
                  end
                  #averiguar precio con el sku
                  precio = get_price_with_sku(c.sku)
                  despachar_stock(c.sku, direccion, precio, num_pedido)
                end
              
                #informar a dw pedido exitoso
              
              
              
              end
            
            
              
            
           
            
            
            
      
            end 
            cont+=1
          end
            
          #procesar (por cada pedidoProducto)
          #Ver si el cliente es vip
          #Si es vip, ver si tiene reserva en gdocs. Si tiene reserva, actualizar el utilizado y pasar al siguiente paso
            
            
            
          #Si no es vip, o no tiene reserva, ver si hay stock en gestion de stock. Si hay, descontar lo que se va a comprar y pasar al siguiente paso. Si no hay, pasar al ultimo paso e informar de quiebre al dw
          #0 no hay, 1 privilegiado, 2 normal
            
          #para cada producto del pedido
            
          
         
          
          
          
          
          if cont>15
            # break
          end
        end
      
      
      
    
      
      end
      
     
      
    end
    
    
  end

  
  
end

