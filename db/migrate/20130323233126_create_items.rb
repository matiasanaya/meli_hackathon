class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :mercado_id
      t.integer :user_id
      t.boolean :has_stock

      t.timestamps
    end
  end
end
