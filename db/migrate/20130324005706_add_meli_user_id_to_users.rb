class AddMeliUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :meli_user_id, :string
  end
end
