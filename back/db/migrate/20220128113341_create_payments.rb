class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.string :user_id
      t.string :holder_name
      t.string :card_number
      t.string :expiration_date
      t.string :security_code

      t.timestamps
    end
  end
end
