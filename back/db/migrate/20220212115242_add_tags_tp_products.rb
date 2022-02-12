class AddTagsTpProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :tags, :json
    add_column :products, :sub_title, :string
  end
end
