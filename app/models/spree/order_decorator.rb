Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address
    go_to_state :payment, :if => lambda { |order| order.payment_required? }
    go_to_state :confirm
    go_to_state :complete





  end

  Spree::Order.state_machine.after_transition :from => :confirm,
                                          :do => :discount_stock

  # If true, causes the payment step to happen during the checkout process
  def payment_required?
    return false
  end

 

def discount_stock
     order = Spree::Order.last
    address = Spree::Address.find(order.bill_address_id)
    products = order.products
    products.each do |product|
      despachar_stock(product.id, address, product.price, order.number)
    end
  end

  

end