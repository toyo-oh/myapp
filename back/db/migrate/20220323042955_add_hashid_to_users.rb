class AddHashidToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :hashid, :string
    add_index :users, :hashid, unique: true
  end
end
