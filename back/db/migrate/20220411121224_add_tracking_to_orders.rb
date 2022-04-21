class AddTrackingToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :slug, :string
    add_column :orders, :tracking_number, :string
  end
end
