
class DashboardsController < ApplicationController
  before_action :set_dashboard, only: [:show, :edit, :update, :destroy]

  # GET /dashboards
  # GET /dashboards.json
  def index

    host = ENV['MONGO_RUBY_DRIVER_HOST'] || 'localhost'
    port = ENV['MONGO_RUBY_DRIVER_PORT'] || Mongo::MongoClient::DEFAULT_PORT

    puts "Connecting to #{host}:#{port}"
    mongo_client = Mongo::MongoClient.new(host, port)
    db = mongo_client.db('integra2-mongodb')
    coll = db.collection('datawarehouse')
    @dw = []
    coll.find().each do |col|
      @dw << {
      :numeropedido=>col['numeropedido'],
      :cliente=>col['nombrecliente'],
      :fecha=>col['fecha'],
      :sku=>col['sku'],
      :producto=>col['producto'],
      :cantidad=>col['cantidad'],
      :rutorganizacion=>col['rutorganizacion'],
      :nombreorganizacion=>col['nombreorganizacion'],
      :direccion=>col['direccion'],
      :quiebre=>col['quiebre']}
    end
    @skus=[]
    @dw.each do |pedido|
      @skus << {:sku=>pedido[:sku].to_i}
    end
    @uniqSku = @skus.uniq()
    @cantidadpedida=[]
    @cantidadquebrada=[]
    @uniqSku.each do |codSku|
      cantAux = 0
      cantAux2 = 0
      @dw.each do |dwpedido|
        if dwpedido[:sku].to_i==codSku[:sku].to_i
          cantAux = cantAux + dwpedido[:cantidad].to_i
          if dwpedido[:quiebre]
            cantAux2 = cantAux2 +1
          end
        end
      end
      @cantidadpedida << {:sku=>codSku[:sku].to_i, :cantidad=>cantAux}
      @cantidadquebrada << {:sku=>codSku[:sku].to_i, :cantidad=>cantAux2}
    end
    @topdiezpedidos = @cantidadpedida.sort_by{|s| -s[:cantidad]}.first(10)
    @topdiezquiebres = @cantidadquebrada.sort_by{|s| -s[:cantidad]}.first(10)
    @skuspedidosordenados=[]
    @skusquiebresordenados=[]
    @cantidadquiebresordenados=[]
    @cantidadpedidosordenados=[]
    @topdiezpedidos.each do |toppedidos|
      @skuspedidosordenados << toppedidos[:sku] 
      @cantidadpedidosordenados<<toppedidos[:cantidad]     
    end
     @topdiezquiebres.each do |topquiebres|
      @skusquiebresordenados << topquiebres[:sku] 
      @cantidadquiebresordenados<<topquiebres[:cantidad]     
    end



    @cantidadpedidosdiarios = []
    @cantidadquiebresdiarios = []
    @from_date = Date.new(2014, 1, 1)
    to_date   = Date.new(2014, 12, 31)
    (@from_date..to_date).each do |d|
      cantAux=0
      cantAux2=0
      @dw.each do |pedido|
        if pedido[:fecha].to_date==d
          cantAux = cantAux+1
          if pedido[:quiebre]
            cantAux2 = cantAux2+1
          end
        end
      end
      @cantidadpedidosdiarios << cantAux
      @cantidadquiebresdiarios << cantAux2
    end


  end

  # GET /dashboards/1
  # GET /dashboards/1.json
  def show
    host = ENV['MONGO_RUBY_DRIVER_HOST'] || 'localhost'
    port = ENV['MONGO_RUBY_DRIVER_PORT'] || Mongo::MongoClient::DEFAULT_PORT

    puts "Connecting to #{host}:#{port}"
    mongo_client = Mongo::MongoClient.new(host, port)
    db = mongo_client.db('integra2-mongodb')
    coll = db.collection('datawarehouse')
    @dw = []
    coll.find().each do |col|
      @dw << {
      :numeropedido=>col['numeropedido'],
      :cliente=>col['nombrecliente'],
      :fecha=>col['fecha'],
      :sku=>col['sku'],
      :producto=>col['producto'],
      :cantidad=>col['cantidad'],
      :rutorganizacion=>col['rutorganizacion'],
      :nombreorganizacion=>col['nombreorganizacion'],
      :direccion=>col['direccion'],
      :quiebre=>col['quiebre']}
    end
  end

  # GET /dashboards/new
  def new
    host = ENV['MONGO_RUBY_DRIVER_HOST'] || 'localhost'
    port = ENV['MONGO_RUBY_DRIVER_PORT'] || Mongo::MongoClient::DEFAULT_PORT

    puts "Connecting to #{host}:#{port}"
    mongo_client = Mongo::MongoClient.new(host, port)
    db = mongo_client.db('integra2-mongodb')
    db.drop_collection("datawarehouse")
    db.create_collection('datawarehouse', :capped => false)
  end

  # GET /dashboards/1/edit
  def edit
  end

  # POST /dashboards
  # POST /dashboards.json
  def create
    @dashboard = Dashboard.new(dashboard_params)

    respond_to do |format|
      if @dashboard.save
        format.html { redirect_to @dashboard, notice: 'Dashboard was successfully created.' }
        format.json { render action: 'show', status: :created, location: @dashboard }
      else
        format.html { render action: 'new' }
        format.json { render json: @dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dashboards/1
  # PATCH/PUT /dashboards/1.json
  def update
    respond_to do |format|
      if @dashboard.update(dashboard_params)
        format.html { redirect_to @dashboard, notice: 'Dashboard was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dashboards/1
  # DELETE /dashboards/1.json
  def destroy
    @dashboard.destroy
    respond_to do |format|
      format.html { redirect_to dashboards_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dashboard
      @dashboard = Dashboard.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dashboard_params
      params[:dashboard]
    end
end
