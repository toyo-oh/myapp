class CreateShippingFees < ActiveRecord::Migration[6.0]
  def change
    create_table :shipping_fees do |t|
      t.string :prefecture
      t.integer :fee

      t.timestamps
    end
  end
end
