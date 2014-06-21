Spree::Order.class_eval do
  
  state_machine :initial => 'address' do 
        after_transition :to => 'complete', :do => :complete_order 
        event :next do 
            transition :to => 'confirm', :from => 'address' 
            transition :to => 'complete', :from => 'confirm' 
            transition :to => 'payment', :from => 'delivery', :if=> 
false 
        end 
    end 

  # If true, causes the payment step to happen during the checkout process
  def payment_required?
    return false
  end

 

def finalize_with_drop_ship!
    finalize_without_drop_ship!
     order = Spree::Order.last
    address = Spree::Address.find(order.bill_address_id)
    products = order.products
    products.each do |product|
      despachar_stock(product.id, address.address1, product.price, order.number)
    end
  end

  

end