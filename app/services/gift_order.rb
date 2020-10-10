class GiftOrder
  def initialize(child_params:, order_params:, gift_params:)
    @child_params = child_params
    @order_params = order_params
    @gift_params = gift_params
  end

  def process_order
    child = find_child
    shipping_params = generate_shipping_params(child: child)

    params = order_params.merge(
      shipping_name: gift_params[:gifter_name],
      message: gift_params[:message],
      child: child,
      user_facing_id: Order.generate_user_facing_id
    ).merge(shipping_params)

    order = Order.create(params)

    order
  end

  private

  attr_reader :child_params, :order_params, :gift_params

  def find_child
    child_full_name = child_params[:full_name]
    parent_name = child_params[:parent_name]
    birthdate = child_params[:birthdate]

    child = Child.find_by(
      full_name: child_full_name,
      parent_name: parent_name,
      birthdate: birthdate
    )

    child
  end

  def generate_shipping_params(child:)
    unless child
      return {}
    end

    previous_order = child.orders.order(:created_at, :desc).first!

    {
      address: previous_order.address,
      zipcode: previous_order.zipcode
    }
  end
end