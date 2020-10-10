class OrdersController < ApplicationController
  def new
    @order = Order.new(product: Product.find(params[:product_id]))
    @is_gift = params[:gift].present?
  end

  def create
    order_form = OrderForm.new(
      order_params: order_params,
      child_params: child_params,
      gift_params: gift_params
    )
    order_form_response = order_form.process_order

    @order = order_form_response.order
    @is_gift = order_form_response.gift?

    if @order.valid?
      Purchaser.new.purchase(@order, credit_card_params)
      redirect_to order_path(@order)
    else
      render :new
    end
  end

  def show
    @order = Order.find_by(id: params[:id]) || Order.find_by(user_facing_id: params[:id])
  end

private

  def order_params
    params.require(:order).permit(:product_id, :zipcode, :address).merge(paid: false)
  end

  def child_params
    {
      full_name: params.require(:order)[:child_full_name],
      parent_name: params.require(:order)[:parent_name],
      birthdate: Date.parse(params.require(:order)[:child_birthdate]),
    }
  end

  def credit_card_params
    params.require(:order).permit( :credit_card_number, :expiration_month, :expiration_year)
  end

  def gift_params
    params.require(:order).permit(:message, :gifter_name)
  end
end
