class CreateBranches < ActiveRecord::Migration[6.0]
  def change
    create_table :branches do |t|
      t.string :name
      t.string :type
      t.string :address
      t.string :serial_num

      t.timestamps
    end
  end
end
