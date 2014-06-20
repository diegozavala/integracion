Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address
   # go_to_state :payment, :if => lambda { |order| order.payment_required? }
    go_to_state :confirm
    go_to_state :complete





  end

  # If true, causes the payment step to happen during the checkout process
  def payment_required?
    return false
  end

 

  def finalize_with_discount_stock!
  a=1
  end
  alias_method_chain :finalize!, :notify_shops

  

end