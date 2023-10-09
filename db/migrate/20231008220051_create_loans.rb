class CreateLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :loans do |t|
      t.string :name
      t.string :commentary
      t.integer :principal
      t.float :interest
      t.integer :loan_term_in_months
      t.string :payment_frequency
      t.datetime :start_date
      t.boolean :payments_at_end_of_period
      t.references :entity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
