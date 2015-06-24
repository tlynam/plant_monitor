class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.float :temperature
      t.float :humidity
      t.float :dewpoint

      t.timestamps null: false
    end
  end
end
