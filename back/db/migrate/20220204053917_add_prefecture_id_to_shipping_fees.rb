class AddPrefectureIdToShippingFees < ActiveRecord::Migration[6.0]
  def change
    add_column :shipping_fees, :prefecture_id, :integer
    add_column :shipping_fees, :city, :string
    add_column :shipping_fees, :detail, :string
  end
end
