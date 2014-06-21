Order.state_machine :initial => 'address' do 
        after_transition :to => 'complete', :do => :complete_order 
        event :next do 
            transition :to => 'confirm', :from => 'address' 
            transition :to => 'complete', :from => 'confirm' 
        end 
    end 

Spree::Order.class_eval do
  
  

  # If true, causes the payment step to happen during the checkout process
  def payment_required?
    return false
  end

 

def complete_order 
     order = Spree::Order.last
    address = Spree::Address.find(order.bill_address_id)
    products = order.products
    products.each do |product|
      despachar_stock(product.id, address.address1, product.price, order.number)
    end
  end

  

end