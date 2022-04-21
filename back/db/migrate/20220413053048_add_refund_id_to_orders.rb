class AddRefundIdToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :refund_id, :string
  end
end
