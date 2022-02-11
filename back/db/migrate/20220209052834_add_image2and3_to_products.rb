class AddImage2and3ToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :image2, :string
    add_column :products, :image3, :string
  end
end
