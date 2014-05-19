class ApiController < ApplicationController
  protect_from_forgery with: :null_session
def pedir_productos

render :json => { :errors => "funciona"}


end

end
