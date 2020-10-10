class OrderForm
  OrderFormResponse = Struct.new(
    :order,
    :gift?,
    keyword_init: true
  )

  def initialize(child_params:, order_params:, gift_params:)
    @child_params = child_params
    @order_params = order_params
    @gift_params = gift_params
  end

  def process_order(standard_order_klass: StandardOrder, gift_order_klass: GiftOrder)
    if gift?
      gift_order = gift_order_klass.new(
        child_params: child_params,
        order_params: order_params,
        gift_params: gift_params
      )

      order = gift_order.process_order

      OrderFormResponse.new(
        order: order,
        gift?: true
      )
    else
      standard_order = standard_order_klass.new(
        child_params: child_params,
        order_params: order_params
      )

      order = standard_order.process_order

      OrderFormResponse.new(
        order: order,
        gift?: false
      )
    end
  end

  private

  attr_reader :child_params, :order_params, :gift_params

  def gift?
    gift_params[:message].present? && gift_params[:gifter_name].present?
  end
end