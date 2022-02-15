class AddIsActiveToPromotions < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :is_active, :boolean, default: false
  end
end
