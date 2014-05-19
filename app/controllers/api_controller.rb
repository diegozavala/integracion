class ApiController < ApplicationController
protect_from_forgery with: :exception
def pedir_productos

render :json => { :errors => "funciona"}


end

end
