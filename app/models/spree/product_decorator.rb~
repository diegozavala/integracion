Spree::Product.class_eval do
  has_many :pedidos, through: :pedido_producto

def on_hand_with_assembly(reload = false)
    if self.assembly? && Spree::Config[:track_inventory_levels]
      parts(reload).map{|v| v.on_hand / self.count_of(v) }.min
    else
      on_hand_without_assembly
    end
  end
  alias_method_chain :on_hand, :assembly

  alias_method :orig_on_hand=, :on_hand=
  def on_hand=(new_level)
    self.orig_on_hand=(new_level) unless self.assembly?
  end

  alias_method :orig_has_stock?, :has_stock?
  def has_stock?
    if self.assembly? && Spree::Config[:track_inventory_levels]
      !parts.detect{|v| self.count_of(v) > v.on_hand}
    else
      self.orig_has_stock?
    end
  end
end
