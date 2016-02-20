require 'csv'

class PatchUploader
  include Sidekiq::Worker

  def perform(id)
    patch = Patch.find(id)

    CSV.open(file_name = "patch_#{patch.version}.csv", "w") do |w|
      w << %w(name author singer beat_link lyric_link)
      patch.songs.each do |song|
        w << [song.name, song.author, song.singer, song.beat_link, song.lyric_link]
      end
    end

    $client.put_file("/#{file_name}", open(file_name))
    response = $session.do_get "/shares/auto/#{$client.format_path('/' + file_name)}", {"short_url"=>false}
    result = Dropbox::parse_response(response)
    patch.update(link: result['url'].gsub('?dl=0', '?dl=1'))
  rescue Exception => e
    p e
  end
end
