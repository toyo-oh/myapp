class AddColumnsToOrderDetails < ActiveRecord::Migration[6.0]
  def change
    remove_column :order_details, :number, :integer
    remove_column :order_details, :product_name, :string
    add_column :order_details, :quantity, :integer
    add_column :order_details, :product_title, :string
    add_column :order_details, :order_id, :integer
    add_column :order_details, :price, :integer
  end
end
