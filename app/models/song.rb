class Song < ActiveRecord::Base
  belongs_to :patch
  has_many :lines

  DEFAULT_WORD_DURATION = 300

  before_save :build_lines

  def upload
    file = "#{id}.mp3"
    $client.put_file("/#{file}", open("public/audios/" + file_name))
    response = $session.do_get "/shares/auto/#{$client.format_path('/' + file)}", {"short_url"=>false}
    result = Dropbox::parse_response(response)
    update(beat_link: result['url'].gsub('?dl=0', '?dl=1'))
  end

  def build_lines
    if lyric_changed?
      processed_at = Word.where(line: Line.where(song: self)).maximum(:processed_at).to_i

      lines_count = lines.count
      new_lines = lyric.split(/\r\n|\n/)

      new_lines.each_with_index do |str_line, index|
        next if index < lines_count
        line = Line.create(song: self, position: index)

        words = []

        str_line.split(/[+.,?!\-: ]+/).each do |str_word|
          processed_at += DEFAULT_WORD_DURATION
          words << Word.new(content: str_word, note: 0, duration: DEFAULT_WORD_DURATION, processed_at: processed_at, line: line)
        end

        Word.import(words)
      end

      lines.where('position >= ?', new_lines.count).delete_all
    end
  end
end
