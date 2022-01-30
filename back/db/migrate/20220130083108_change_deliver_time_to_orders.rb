class ChangeDeliverTimeToOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :deliverTime, :datetime
    add_column :orders, :deliver_at, :datetime
  end
end
