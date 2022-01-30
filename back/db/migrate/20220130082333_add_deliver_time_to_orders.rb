class AddDeliverTimeToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :deliverTime, :datetime
  end
end
