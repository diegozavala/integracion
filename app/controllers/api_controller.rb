class ApiController < ApplicationController

def pedir_productos

user_name=params[:usuario]
user_pass=params[:password]
if ApiUser.where(:name => user_name).where(:password => user_pass).blank?
	render :json => { :errors => "nofunciona"}
else
	render :json => { :errors => "funciona"}
end



end

end
