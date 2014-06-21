include ApplicationHelper

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
    discount_stock
  end

  alias_method_chain :finalize!, :discount_stock

  def discount_stock
     order = Spree::Orders.last
    address = Spree::Addresses.find(order.bill_address_id)
    products = order.products
    products.each do |product|
      despachar_stock(product.id, address, product.price, order.number)
    end
  end 
  

end