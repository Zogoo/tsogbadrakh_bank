class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.integer :kind
      t.integer :status, default: 0
      t.string :currency, default: 'usd'
      t.bigint :balance, default: 0
      t.integer :interest_rate, default: 0
      t.integer :interest_period, default: 0

      t.references :user, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
