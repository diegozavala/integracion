class ApiController < ApplicationController

protect_from_forgery with: null_session
def pedir_productos

user_name=params[:usuario]
user_pass=params[:password]
if ApiUser.where(:name => user_name).where(:password => user_pass).blank?
	render :json => { :errors => "no funciona"}
else
render :json => { :errors => "funciona"}
end



end

end
