class AddWaveformFileToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :waveform_file, :string
  end
end
