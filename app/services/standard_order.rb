class StandardOrder
  def initialize(child_params:, order_params:)
    @child_params = child_params
    @order_params = order_params
  end

  def process_order
    child = Child.find_or_create_by(child_params)

    order = Order.create(
      order_params.merge(
        shipping_name: child_params[:parent_name],
        child: child,
        user_facing_id: Order.generate_user_facing_id
      )
    )

    order
  end

  private

  attr_reader :child_params, :order_params
end