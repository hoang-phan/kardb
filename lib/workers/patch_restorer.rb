require 'open-uri'
require 'csv'

class PatchRestorer
  include Sidekiq::Worker

  def perform(id)
    patch = Patch.find(id)

    csv = CSV.parse(open(patch.link).read, headers: true)

    csv.each do |row|
      song = Song.create(
        author: row['author'],
        singer: row['singer'],
        name: row['name'],
        beat_link: row['beat_link'],
        lyric_link: row['lyric_link'],
        words_link: row['words_link'],
        patch: patch
      )
      SongRestorer.perform_async(song.id)
    end
  rescue Exception => e
    p e
  end
end
