class Merchant::BulkDiscountsController < Merchant::BaseController

  def index
    @discounts = current_user.merchant.bulk_discounts
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @discount = BulkDiscount.new
  end

end
