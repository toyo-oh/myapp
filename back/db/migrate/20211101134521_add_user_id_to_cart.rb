class AddUserIdToCart < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :user_id, :string
  end
end
