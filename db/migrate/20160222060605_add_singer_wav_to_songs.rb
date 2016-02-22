class AddSingerWavToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :singer_wav, :string
  end
end
