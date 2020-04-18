class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def applied_discount(item_id)
    discounts = merchant_discounts(item_id).select {|discount| count_of(item_id) >= discount.item_threshold}
    discounts.max_by(&:discount_percentage).discount_percentage unless discounts.empty?
  end

  def item_threshold_met?(item_id)
    applied_discount(item_id).present?
  end

  private

  def merchant_discounts(item_id)
    Item.find(item_id).merchant.bulk_discounts
  end

end
