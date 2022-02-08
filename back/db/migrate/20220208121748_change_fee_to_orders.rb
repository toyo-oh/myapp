class ChangeFeeToOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :logistics_fee, :integer
    add_column :orders, :shipping_fee, :integer
  end
end
