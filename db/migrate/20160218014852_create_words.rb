class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :content
      t.integer :note
      t.integer :duration
      t.integer :processed_at
      t.references :line, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps null: false
    end

    add_index :words, :processed_at
    add_index :words, :note
  end
end
