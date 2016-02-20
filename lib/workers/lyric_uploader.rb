class LyricUploader
  include Sidekiq::Worker

  def perform(id)
    file_name = "#{id}.lyr"

    song = Song.find(id)
    File.open(file_name, 'w') do |f|
      song.lines.each do |line|
        f.write '-' 
        content = line.words.pluck(:content, :note, :processed_at, :duration).map do |words|
          words.map(&:to_s).join(',')
        end.join("\n")
        f.write content + "\n"
      end
    end

    $client.put_file("/#{file_name}", open(file_name))
    response = $session.do_get "/shares/auto/#{$client.format_path('/' + file_name)}", {"short_url"=>false}
    result = Dropbox::parse_response(response)
    song.update(lyric_link: result['url'].gsub('?dl=0', '?dl=1'))
  rescue Exception => e
    p e
  end
end
