class CreateTextQueries < ActiveRecord::Migration
  def change
    create_table :text_queries do |t|
      t.string :text
      t.string :response

      t.timestamps
    end
  end
end
