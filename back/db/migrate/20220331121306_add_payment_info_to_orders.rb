class AddPaymentInfoToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :customer_id, :string
    add_column :orders, :charge_id, :string
    add_column :orders, :last4, :string
    add_column :orders, :pay_error, :string
  end
end
