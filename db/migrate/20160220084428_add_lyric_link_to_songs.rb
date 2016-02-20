class AddLyricLinkToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :lyric_link, :string
  end
end
