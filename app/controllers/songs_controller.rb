class SongsController < ApplicationController
  before_action :set_song, only: [:update, :show]

  def pull
    SongsPuller.perform_async
    redirect_to :back
  end

  def index
    @songs = Song.all
  end

  def show

  end

  def create
    Song.create(song_params)
    redirect_to :back, notice: 'Created'
  end

  def update
    @song.update(song_params)
    redirect_to :back, notice: 'Updated'
  end

  def upload
    SongUploader.perform_async(params[:id])
    redirect_to :back, notice: 'Uploaded'
  end

  private

  def set_song
    @song = Song.find(params[:id])
  end

  def song_params
    params.require(:song).permit(:name, :author, :singer, :file_name, :lyric)
  end
end
