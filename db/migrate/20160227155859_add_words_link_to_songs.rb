class AddWordsLinkToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :words_link, :string
  end
end
