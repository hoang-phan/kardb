class AddFileNameToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :file_name, :string
    add_index :songs, :file_name
  end
end
