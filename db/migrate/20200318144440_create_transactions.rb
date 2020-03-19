class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.integer :status
      t.bigint :amount
      t.integer :receiver_id

      t.references :account, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    add_index :transactions, :receiver_id
  end
end
