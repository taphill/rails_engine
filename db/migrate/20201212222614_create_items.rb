class CreateItems < ActiveRecord::Migration[5.2]
  def change
    unless ActiveRecord::Base.connection.table_exists?('items')
      create_table :items do |t|
        t.references :merchant, foreign_key: true
        t.string :name
        t.string :description
        t.float :unit_price

        t.timestamps
      end
    end
  end
end
