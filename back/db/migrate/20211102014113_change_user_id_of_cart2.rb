class ChangeUserIdOfCart2 < ActiveRecord::Migration[6.0]
  def change
    remove_column :carts, :user_id, :string
    add_reference :carts, :user, foreign_key: true, index: true
  end
end
