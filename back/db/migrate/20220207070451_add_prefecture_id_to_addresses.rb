class AddPrefectureIdToAddresses < ActiveRecord::Migration[6.0]
  def change
    remove_column :shipping_fees, :prefecture_id, :integer
    remove_column :shipping_fees, :city, :string
    remove_column :shipping_fees, :detail, :string
    add_column :addresses, :prefecture_id, :integer
    add_column :addresses, :city, :string
    add_column :addresses, :detail, :string
  end
end
