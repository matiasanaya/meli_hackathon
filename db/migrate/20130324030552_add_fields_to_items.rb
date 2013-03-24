class AddFieldsToItems < ActiveRecord::Migration
  #:has_stock, :meli_id, :user_id, :meli_stock, :meli_title, :stock_tracked, :sold_quantity, :real_stock
  def change
    rename_column :items, :mercado_id, :meli_id
    add_column :items, :meli_stock, :integer
    add_column :items, :meli_title, :string
    add_column :items, :stock_tracked, :boolean
    add_column :items, :sold_quantity, :integer
    add_column :items, :real_stock, :integer
  end
end
