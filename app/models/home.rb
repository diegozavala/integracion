class Home < ActiveRecord::Base





  def test_ftp 
    require 'net/sftp' 
   
    sftp2=Net::SFTP
    sftp2.start('integra.ing.puc.cl','grupo2', :password => 'apijd9292') do |sftp|
      
      cont=0
      sftp.dir.foreach("/home/grupo2/Pedidos") do |entry|
        cont+=1
      end
      @status=sftp.download!("/home/grupo2/Pedidos/pedido_10.xml")
    end
    
  end

  
  
end
