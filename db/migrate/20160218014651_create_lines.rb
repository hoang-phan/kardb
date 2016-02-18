class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.references :song, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps null: false
    end
  end
end
