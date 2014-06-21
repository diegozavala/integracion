Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address
   # go_to_state :payment, :if => lambda { |order| order.payment_required? }
    go_to_state :confirm
    go_to_state :complete
  end


  

end