
class Home < ActiveRecord::Base
  helper :all



  def test_ftp 
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
      
      
            pedi = doc.xpath("//Pedido")
            pedi.each do |p|
              sku = p.xpath("sku").text
    
              cant = p.xpath("cantidad").text
              un = p.at_xpath("cantidad")["unidad"]
              prod = Producto.find_or_create_by(sku: sku)
              #prod = Spree::Product.where(:sku => sku)["id"]
              PedidoProducto.create(:pedido_id => pedido.id, :producto_id => prod.id, :cantidad => cant , :unidad => un)
              
              
              

              

            end
            
            #procesar (por cada pedidoProducto)
            #Ver si el cliente es vip
            #Si es vip, ver si tiene reserva en gdocs. Si tiene reserva, actualizar el utilizado y pasar al siguiente paso
            
            
            
            #Si no es vip, o no tiene reserva, ver si hay stock en gestion de stock. Si hay, descontar lo que se va a comprar y pasar al siguiente paso. Si no hay, pasar al ultimo paso e informar de quiebre al dw
            hay_stock = [] #0 no hay, 1 privilegiado, 2 normal
            i=0
            #para cada producto del pedido
            pedido.productos.each do |c|
              hay_stock[i] = 0
              #vemos stocks privilegiados
              get_num_rows_gdoc.times do |j|
                linea=get_row_gdoc(j+4)
                if(linea[1]==rut and linea[2]==sku and (linea[3]-linea[4])>c.cantidad) 
                  hay_stock[i] = 1
                  break
                  #actualizar linea[4]=linea[4]-c.cantidad
                end
              end
              
              #si no hay privilegiado, veamos normal
              if( hay_stock[i] ==0 and get_stock(53571c4f682f95b80b7563e6, c.sku)>c.cantidad)
                hay_stock[i] = 2
              end
              i+=1
            end
            
            if hay_stock.find(0)
              #informar quiebre de pedido a dw. ¿Se mandan los productos que si estan???
              
            else
              
              #averiguar direccion del cliente
              #direccion = 
              pedido.productos.each do |c|
                #pasar stock a despacho
                c.cantidad.times do
                  mover_stock_bodega(c.sku, 53571c4f682f95b80b7563e5)
                end
                #averiguar precio con el sku
                # precio = 
                #despachar_stock(c.sku, direccion, precio, num_pedido)
              end
              
              #informar a dw pedido exitoso
              
              
              
            end
            
            
              
            
            
            #buscar direccion de despacho en vtiger con la direccionId
            #buscar el precio en la bd que viene de dropbox
            #realizar movimientos en bodega (gestion de stock) para dejar el producto en la bodega de despacho
            #despachar (gestion de stock)
            #realizar informe de venta/quiebre al dw
            
            
            
      
          end
         
          
          
          
          cont+=1
            
        end
      
      
      
    
      
      end
      
     
      
    end
    
    
  end

  
  
end

