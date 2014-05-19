class Home < ActiveRecord::Base
  helper :all



  def test_ftp 
    require 'net/sftp' 
   
    sftp2=Net::SFTP
    sftp2.start('integra.ing.puc.cl','grupo2', :password => 'apijd9292') do |sftp|
      
      cont=0
      sftp.dir.foreach("/home/grupo2/Pedidos") do |entry|
        if entry.name.downcase.include? ".xml"
           
          FtpPedido.find_or_create_by(nombre_archivo: entry.name, numero_pedido: entry.name[entry.name.index('_')+1..entry.name.index('.')-1] ) do |c|
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
            hay_stock=true
            
            pedido.productos.each do |c|
              
              if(get_stock(almace, c.sku)>0)
                
              end
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
