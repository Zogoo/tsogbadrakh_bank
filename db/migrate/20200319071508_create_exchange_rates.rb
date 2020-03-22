class CreateExchangeRates < ActiveRecord::Migration[6.0]
  def change
    create_table :exchange_rates do |t|
      t.string :currency_from
      t.string :currency_to
      t.bigint :rate
      t.datetime :added_at

      t.timestamps
    end
    
    add_index :exchange_rates, :added_at
  end
end
