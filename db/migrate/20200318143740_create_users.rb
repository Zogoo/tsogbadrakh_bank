class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :uuid, default: ''
      t.integer :status, default: 0
      t.boolean :is_confirmed, default: false
      t.date :registration_date

      t.references :branch

      t.timestamps
    end

    add_index :users, :uuid, unique: true
    add_index :users, :status
  end
end
