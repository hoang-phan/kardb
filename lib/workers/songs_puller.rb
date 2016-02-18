class SongsPuller
  include Sidekiq::Worker

  def perform
    Song.pluck(:id).each do |id|
      SongPuller.perform_async(id)
    end
  end
end
