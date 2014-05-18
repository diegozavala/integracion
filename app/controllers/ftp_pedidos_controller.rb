class FtpPedidosController < ApplicationController
  before_action :set_ftp_pedido, only: [:show, :edit, :update, :destroy]

  # GET /ftp_pedidos
  # GET /ftp_pedidos.json
  def index
    @ftp_pedidos = FtpPedido.all
  end

  # GET /ftp_pedidos/1
  # GET /ftp_pedidos/1.json
  def show
  end

  # GET /ftp_pedidos/new
  def new
    @ftp_pedido = FtpPedido.new
  end

  # GET /ftp_pedidos/1/edit
  def edit
  end

  # POST /ftp_pedidos
  # POST /ftp_pedidos.json
  def create
    @ftp_pedido = FtpPedido.new(ftp_pedido_params)

    respond_to do |format|
      if @ftp_pedido.save
        format.html { redirect_to @ftp_pedido, notice: 'Ftp pedido was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ftp_pedido }
      else
        format.html { render action: 'new' }
        format.json { render json: @ftp_pedido.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ftp_pedidos/1
  # PATCH/PUT /ftp_pedidos/1.json
  def update
    respond_to do |format|
      if @ftp_pedido.update(ftp_pedido_params)
        format.html { redirect_to @ftp_pedido, notice: 'Ftp pedido was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ftp_pedido.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ftp_pedidos/1
  # DELETE /ftp_pedidos/1.json
  def destroy
    @ftp_pedido.destroy
    respond_to do |format|
      format.html { redirect_to ftp_pedidos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ftp_pedido
      @ftp_pedido = FtpPedido.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ftp_pedido_params
      params.require(:ftp_pedido).permit(:nombre_archivo, :numero_pedido, :fecha_procesado)
    end
end
