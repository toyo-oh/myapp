class ChangeUserIdToPayments < ActiveRecord::Migration[6.0]
  def change
    remove_column :payments, :user_id, :string
    add_column :payments, :user_id, :integer
  end
end
