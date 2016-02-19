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
      Line.where(song: self).delete_all

      processed_at = DEFAULT_WORD_DURATION

      lyric.split(/\r\n|\n/).each do |str_line|
        line = Line.create(song: self)

        words = []

        str_line.split(/[+.,?!\-: ]+/).each do |str_word|
          processed_at += DEFAULT_WORD_DURATION
          words << Word.new(content: str_word, note: 0, duration: DEFAULT_WORD_DURATION, processed_at: processed_at, line: line)
        end

        Word.import(words)
      end
    end
  end

  def display_lines
    lines.includes(:words).map do |line|
      line.words.map(&:content).join(' ')
    end
  end
end
