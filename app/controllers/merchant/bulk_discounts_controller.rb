class Merchant::BulkDiscountsController < Merchant::BaseController

  def index
    @discounts = my_discounts
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @discount = BulkDiscount.new
  end

  def create
    my_discounts.create(discount_params)
    redirect_to merchant_bulk_discounts_path
  end

  private

  def my_discounts
    current_user.merchant.bulk_discounts
  end

  def discount_params
    params.require(:bulk_discount).permit(:discount_percentage, :item_threshold)
  end

end
