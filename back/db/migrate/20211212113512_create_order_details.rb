class CreateOrderDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :order_details do |t|
      t.string :order_no
      t.integer :product_id
      t.string :product_name
      t.integer :number
      t.float :discount
      t.integer :subtotal
      t.text :remark

      t.timestamps
    end
  end
end
