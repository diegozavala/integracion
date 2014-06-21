Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address
   # go_to_state :payment, :if => lambda { |order| order.payment_required? }
    go_to_state :confirm
    before_transition :to => :complete ,:do => :discount_stock

    go_to_state :complete


before_transition :to => :delivery,:do => :valid_geolocation?


  end

  # If true, causes the payment step to happen during the checkout process
  def payment_required?
    return false
  end

 

def discount_stock
    order = Spree::Order.last
    address = Spree::Address.find(order.bill_address_id)
    products = order.products
    products.each do |product|
      despachar_stock(product.id, address.address1, product.price, order.number)
    end    
  end

  

end