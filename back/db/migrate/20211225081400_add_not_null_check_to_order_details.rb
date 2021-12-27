class AddNotNullCheckToOrderDetails < ActiveRecord::Migration[6.0]
  def change
    change_column_null :order_details, :order_id, false
    change_column_null :order_details, :product_id, false
  end
end
