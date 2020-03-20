class CreateExchangeRates < ActiveRecord::Migration[6.0]
  def change
    create_table :exchange_rates do |t|
      t.string :from
      t.string :to
      t.float :rate
      t.datetime :added_at

      t.timestamps
    end
    
    add_index :exchange_rates, :added_at
  end
end
