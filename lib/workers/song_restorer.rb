require 'open-uri'
require 'csv'

class SongRestorer
  include Sidekiq::Worker

  def perform(id)
    song = Song.find(id)

    csv = CSV.parse(open(song.lyric_link).read, headers: true)

    csv.each do |row|
      Line.create(
        id: row['id'],
        position: row['position'].to_i,
        song: song
      )
    end

    csv = CSV.parse(open(song.words_link).read, headers: true)

    csv.each do |row|
      Word.create(
        id: row['id'],
        content: row['content'],
        processed_at: row['processed_at'].to_i,
        duration: row['duration'].to_i,
        note: row['note'].to_i,
        line_id: row['line_id'].to_i
      )
    end
  rescue Exception => e
    p e
  end
end
