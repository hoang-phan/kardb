class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :beat_link
      t.string :name
      t.string :author
      t.string :singer
      t.references :patch, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps null: false
    end
  end
end
