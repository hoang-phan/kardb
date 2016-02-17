class CreatePatches < ActiveRecord::Migration
  def change
    create_table :patches do |t|
      t.integer :version
      t.string :link

      t.timestamps null: false
    end
  end
end
