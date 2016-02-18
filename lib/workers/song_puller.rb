require 'open-uri'

class SongPuller
  include Sidekiq::Worker

  def perform(id)
    song = Song.find(id)
    file_name = "public/audios/#{song.file_name}"
    unless File.exist?(file_name)
      open(file_name, 'wb') do |file|
        file << open(song.beat_link).read
      end
    end
  rescue Exception => e
    p e
  end
end
