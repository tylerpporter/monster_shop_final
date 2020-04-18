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
    @discount = my_discounts.create(discount_params)
    @discount.save ? success(@discount) : failure(@discount)
  end

  def edit
    @discount = my_discounts.find(params[:id])
  end

  def update
    @discount = my_discounts.update(params[:id], discount_params)
    @discount.save ? success(@discount) : failure(@discount)
  end

  def destroy
    my_discounts.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path
  end

  private

  def my_discounts
    current_user.merchant.bulk_discounts
  end

  def discount_params
    params.require(:bulk_discount).permit(:discount_percentage, :item_threshold)
  end

  def success(discount)
    flash[:notice] = 'New bulk discount created' if params[:action] == "create"
    flash[:notice] = "Bulk discount with ID: #{discount.id} successfully updated" if params[:action] == "update"
    redirect_to merchant_bulk_discounts_path
  end

  def failure(discount)
    generate_flash(@discount)
    render :new if params[:action] == "create"
    render :edit if params[:action] == "update"
  end

end
