class ChangePaymentToOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :pay_channel, :string
    add_column :orders, :payment_id, :integer
  end
end
