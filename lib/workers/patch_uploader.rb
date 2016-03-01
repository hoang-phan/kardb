require 'csv'

class PatchUploader
  include Sidekiq::Worker

  def perform(id)
    patch = Patch.find(id)

    CSV.open(file_name = "patch_#{patch.version}.csv", "w") do |w|
      w << %w(id name author singer beat_link lyric_link words_link)
      patch.songs.each do |song|
        w << [song.id, song.name, song.author, song.singer, song.beat_link, song.lyric_link, song.words_link]
      end
    end

    begin
      $client.file_delete("/#{file_name}")
    rescue
      p 'File is ready'
    end

    $client.put_file("/#{file_name}", open(file_name))
    result = $client.shares "/#{file_name}", false
    patch.update(link: result['url'].gsub('?dl=0', '?dl=1'))
  rescue Exception => e
    p e
  end
end
