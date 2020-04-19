class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def apply_discount(discount)
    percentage = (discount.to_f / 100)
    reduction = (price * percentage).round(2)
    update(price: price - reduction, bulk_discount: discount)
  end

  def subtotal
    quantity * price
  end

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end
end
