Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address
   # go_to_state :payment, :if => lambda { |order| order.payment_required? }
    go_to_state :confirm, :if => lambda { |order| order.confirmation_required? }
    go_to_state :complete, :do => discount_stock

    after_transition :to => :complete,:do => :notify_shops_new_order


  end

  # If true, causes the payment step to happen during the checkout process
  def payment_required?
    return false
  end

  # If true, causes the confirmation step to happen during the checkout process
  def confirmation_required?
    return true
  end
  def discount_stock
    break
  end

  def finalize_with_notify_shops!
  finalize_without_notify_shops!
  notify_shops_new_order
  end
  alias_method_chain :finalize!, :notify_shops

  def notify_shops_new_order
    a=1
  end

end