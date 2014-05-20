class ApiController < ApplicationController
  protect_from_forgery with: :null_session

include ApplicationHelper

def pedir_productos

user_name=params[:usuario]
user_pass=params[:password]
bodega_destino = params[:almacen_id]
sku = params[:SKU]
cantidad = params[:cantidad]

if ApiUser.where(:name => user_name).where(:password => user_pass).blank?
	render :json => { :error => "usuario o contraseña incorrectos"}
else
	response = mover_stock_cantidad(sku, bodega_destino, cantidad)
	render :json => response
end



end

end
