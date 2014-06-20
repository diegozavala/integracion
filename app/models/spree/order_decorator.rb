Spree::Order.class_eval do
  checkout_flow do
    go_to_state :complete
  end

  # If true, causes the payment step to happen during the checkout process
  def payment_required?
    return false
  end

  # If true, causes the confirmation step to happen during the checkout process
  def confirmation_required?
    return true
  end

end