class Song < ActiveRecord::Base
  belongs_to :patch

  def self.quick_create(name, singer, author, file_name)
    patch = Patch.find_or_create_by(version: Time.current.strftime("%Y%m%d"))
    create(name: name, singer: singer, author: author, file_name: file_name, patch: patch)
  end

  def upload
    file = "#{id}.mp3"
    $client.put_file("/#{file}", open(file_name))
    response = $session.do_get "/shares/auto/#{$client.format_path('/' + file)}", {"short_url"=>false}
    result = Dropbox::parse_response(response)
    update(beat_link: result['url'].gsub('?dl=0', '?dl=1'))
  end
end
