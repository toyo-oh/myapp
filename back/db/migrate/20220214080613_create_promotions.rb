class CreatePromotions < ActiveRecord::Migration[6.0]
  def change
    create_table :promotions do |t|
      t.integer :product_id
      t.string :title
      t.float :discount
      t.string :start_at
      t.string :end_at

      t.timestamps
    end
  end
end
