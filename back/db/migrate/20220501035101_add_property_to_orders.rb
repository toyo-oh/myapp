class AddPropertyToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :order_details, :property, :string
  end
end
