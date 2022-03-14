class AddImageToOrderDetails < ActiveRecord::Migration[6.0]
  def change
    add_column :order_details, :image, :string
  end
end
