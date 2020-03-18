class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.date :birth_date
      t.string :postal_code
      t.string :city
      t.string :address
      t.string :email

      t.references :user, foreign_key: { on_delete: cascade }

      t.timestamps
    end

    add_index :profiles, :first_name
    add_index :profiles, :last_name
  end
end
