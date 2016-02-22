class AddWaveFormSingerToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :wave_form_singer, :string
  end
end
