class RemoveColumnsFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :image, :string
    remove_column :products, :image2, :string
    remove_column :products, :image3, :string
  end
end
