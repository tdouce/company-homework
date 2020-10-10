class Order < ApplicationRecord
  belongs_to :product
  belongs_to :child

  validates :shipping_name, presence: true
  validates :message, length: { maximum: 1000 }

  def self.generate_user_facing_id(secure_random_klass: SecureRandom)
    secure_random_klass.uuid[0..7]
  end

  def to_param
    user_facing_id
  end
end
