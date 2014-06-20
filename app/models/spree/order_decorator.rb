Spree::Order.class_eval do
  checkout_flow do
    redirect_to :controller => "homes",:action => "index" 
  end

end