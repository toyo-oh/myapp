class AddIsDefaultToPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :is_default, :boolean, default: false
  end
end
