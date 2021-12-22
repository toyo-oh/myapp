class AddIsDefaultToAddresses < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses, :is_default, :boolean, default: false
  end
end
