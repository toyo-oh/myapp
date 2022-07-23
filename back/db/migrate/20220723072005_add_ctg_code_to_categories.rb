class AddCtgCodeToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :ctg_code, :string
  end
end
