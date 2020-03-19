class CreateBranches < ActiveRecord::Migration[6.0]
  def change
    create_table :branches do |t|
      t.string :name
      t.string :kind
      t.string :address
      t.string :serial_num

      t.timestamps
    end

    add_index :branches, :serial_num, unique: true
    add_index :branches, :name
    add_index :branches, :kind
  end
end
