class ApiController < ApplicationController
  protect_from_forgery with: :null_session


def pedir_productos

user_name=params[:usuario]
user_pass=params[:password]
bodega_destino = params[:almacen_id]
sku = params[:SKU]
cantidad = params[:cantidad]

if ApiUser.where(:name => user_name).where(:password => user_pass).blank?
	render :json => { :user_name => user_name,
	:user_pass => user_pass,
	:bodega_destino => bodega_destino,
	:sku => sku,
	:cantidad => cantidad
	 }
else
	render :json => { :errors => "funciona"}
end



end

end
