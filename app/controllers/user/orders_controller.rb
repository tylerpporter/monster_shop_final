class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.new
    order.save
    create_order_items(order)
    success
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end

  private

  def create_single_order_item(order, item)
    order.order_items.create({
      item: item,
      quantity: cart.count_of(item.id),
      price: item.price
      })
  end

  def discount_order_item(item, order_item)
    if cart.item_threshold_met?(item.id)
      order_item.apply_discount(cart.applied_discount(item.id))
    end
  end

  def create_order_items(order)
    cart.items.each do |item|
      order_item = create_single_order_item(order, item)
      discount_order_item(item, order_item)
    end
  end

  def success
    session.delete(:cart)
    flash[:notice] = "Order created successfully!"
    redirect_to '/profile/orders'
  end

end
