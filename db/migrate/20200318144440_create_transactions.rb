class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.integer :status
      t.bigint :amount

      t.references :user, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
