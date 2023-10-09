class CreateEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :entities do |t|
      t.string :name
      t.integer :naics_code
      t.datetime :created_date
      t.string :email

      t.timestamps
    end
  end
end
