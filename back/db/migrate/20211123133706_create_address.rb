class CreateAddress < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.string :receiver
      t.string :phone_number
      t.string :postcode
      t.string :address
    end
  end
end
