class HomesController < ApplicationController
  before_action :set_home, only: [:show, :edit, :update, :destroy]

  # GET /homes
  # GET /homes.json
  def index
    test_ftp
    @homes = Home.all
  end

  # GET /homes/1
  # GET /homes/1.json
  def show
  end

  # GET /homes/new
  def new
    @home = Home.new
  end

  # GET /homes/1/edit
  def edit
  end

  # POST /homes
  # POST /homes.json
  def create
    @home = Home.new(home_params)

    respond_to do |format|
      if @home.save
        format.html { redirect_to @home, notice: 'Home was successfully created.' }
        format.json { render action: 'show', status: :created, location: @home }
      else
        format.html { render action: 'new' }
        format.json { render json: @home.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /homes/1
  # PATCH/PUT /homes/1.json
  def update
    respond_to do |format|
      if @home.update(home_params)
        format.html { redirect_to @home, notice: 'Home was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @home.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /homes/1
  # DELETE /homes/1.json
  def destroy
    @home.destroy
    respond_to do |format|
      format.html { redirect_to homes_url }
      format.json { head :no_content }
    end
  end
  
 

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_home
    @home = Home.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def home_params
    params[:home]
  end
    
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
              
            # y procesar
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
              sku = p["sku"]
              
              cant = p["cantidad"]
              un = p["unidad"]
              prod = Producto.find_or_create_by(sku: sku)
              PedidoProducto.create(:pedido_id => pedido.id, :producto_id => prod.id, :cantidad => cant , :unidad => un)
            end
              
          end
      
        end
         
          
          
          
        cont+=1
            
      end
      
      
      
      
      
      
      
    
      
    end
    
  end
    
    
end
