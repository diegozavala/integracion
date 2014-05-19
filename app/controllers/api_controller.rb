class ApiController < ApplicationController

def pedir_productos

user_name=params[:usuario]
user_pass=params[:password]
if ApiUser.where(:name => user_name).where(:password => user_pass).blank?
	render :json => { :errors => "no funciona"}
else

end


render :json => { :errors => "funciona"}
end

end
