class SongUploader
  include Sidekiq::Worker

  def perform(id)
    LyricUploader.perform_async(id)
    Song.find(id).upload
  rescue Exception => e
    p e
  end
end
