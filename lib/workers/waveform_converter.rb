class WaveformConverter
  include Sidekiq::Worker

  def perform(id)
    song = Song.find(id)
    tempname = "public/audios/#{id}.wav"
    path = "public/images/#{id}.png"
    system %Q{ffmpeg -y -i "public/audios/#{song.file_name}" -f wav "#{tempname}" > /dev/null 2>&1}
    FileUtils.rm path
    Waveform.generate(tempname, path)
    FileUtils.rm tempname
    song.update(waveform_file: "#{id}.png")
  rescue Exception => e
    p e
  end
end
