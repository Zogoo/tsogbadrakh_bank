class CreateExchangeRates < ActiveRecord::Migration[6.0]
  def change
    create_table :exchange_rates do |t|
      t.string :from
      t.string :to
      t.bigint :rate
      t.integer :status
      t.datetime :current_timestamp

      t.timestamps
    end
    
    add_index :exchange_rates, :from
    add_index :exchange_rates, :to
  end
end
