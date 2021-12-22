class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :order_no
      t.string :order_status
      t.integer :product_count
      t.integer :amount_total
      t.integer :logistics_fee
      t.integer :user_id
      t.integer :address_id
      t.string :pay_channel
      t.boolean :is_paid

      t.timestamps
    end
  end
end
