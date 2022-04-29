class AddIsActivedToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_activated, :boolean, default: false
  end
end
