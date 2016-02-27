class LyricUploader
  include Sidekiq::Worker

  def perform(id)
    lines_file_name = "ll_#{id}.csv"
    words_file_name = "lw_#{id}.csv"

    song = Song.find(id)
    lines = song.lines.includes(:words)

    CSV.open(lines_file_name, 'w') do |csv|
      csv << %w(id position)
      lines.each do |line|
        csv << [line.id, line.position]
      end
    end

    CSV.open(words_file_name, 'w') do |csv|
      csv << %w(id content processed_at duration note line_id)
      lines.each do |line|
        line.words.each do |word|
          csv << [word.id, word.content, word.processed_at, word.duration, word.note, line.id]
        end
      end
    end

    $client.put_file("/#{lines_file_name}", open(lines_file_name))
    response = $session.do_get "/shares/auto/#{$client.format_path('/' + lines_file_name)}", {"short_url"=>false}
    result = Dropbox::parse_response(response)
    song.update(lyric_link: result['url'].gsub('?dl=0', '?dl=1'))

    $client.put_file("/#{words_file_name}", open(words_file_name))
    response = $session.do_get "/shares/auto/#{$client.format_path('/' + words_file_name)}", {"short_url"=>false}
    result = Dropbox::parse_response(response)
    song.update(words_link: result['url'].gsub('?dl=0', '?dl=1'))
  rescue Exception => e
    p e
  end
end
