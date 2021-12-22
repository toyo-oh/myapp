class ChangeNewDefaultOfAddresses < ActiveRecord::Migration[6.0]
  def change
    change_column :addresses, :default, :boolean, default:false
  end
end
