class Order < ApplicationRecord
  belongs_to :product
  belongs_to :child

  validates :shipping_name, presence: true
  validates :message, length: { maximum: 1000 }

  def to_param
    user_facing_id
  end
end
