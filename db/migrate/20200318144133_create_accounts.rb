class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :type
      t.integer :status
      t.bigint :balance
      t.integer :interest
      t.integer :interest_period

      t.references :user, foreign_key: { on_delete: cascade }

      t.timestamps
    end
  end
end
