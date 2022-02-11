class AddNewColumnsToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :is_available, :boolean
    add_column :products, :category_id, :integer
  end
end
