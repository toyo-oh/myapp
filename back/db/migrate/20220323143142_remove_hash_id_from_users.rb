class RemoveHashIdFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :hashid, :string
  end
end
