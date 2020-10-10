class AddMessageToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column(:orders, :message, :string, limit: 1000)
  end
end
