class SongsController < ApplicationController
  before_action :set_song, only: [:update, :destroy, :upload]

  def index
    @songs = Song.all
  end

  def create
    Song.create(song_params)
    redirect_to songs_path, notice: 'Created'
  end

  def update
    @song.update(song_params)
    redirect_to songs_path, notice: 'Updated'
  end

  def destroy
    @song.delete
    redirect_to songs_path, notice: 'Deleted'
  end

  def upload
    @song.upload
    redirect_to songs_path, notice: 'Uploaded'
  end

  private

  def set_song
    @song = Song.find(params[:id])
  end

  def song_params
    params.require(:song).permit(:name, :author, :singer, :file_name)
  end
end
