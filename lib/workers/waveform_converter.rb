class WaveformConverter
  include Sidekiq::Worker

  def perform(id)
    song = Song.find(id)
    tempname = "public/audios/#{id}.wav"
    path = "public/images/#{id}.png"
    system %Q{ffmpeg -y -i "public/audios/#{song.file_name}" -f wav "#{tempname}" > /dev/null 2>&1}
    FileUtils.rm_rf path
    Waveform.generate(tempname, path, width: 18000)
    FileUtils.rm_rf tempname
    image = MiniMagick::Image.open(path)
    image.rotate(90)
    image.write(path)
    song.update(waveform_file: "#{id}.png")

    tempname = "public/audios/#{id}_singer.wav"
    path = "public/images/#{id}_singer.png"
    system %Q{ffmpeg -y -i "public/audios/#{song.singer_wav}" -f wav "#{tempname}" > /dev/null 2>&1}
    FileUtils.rm_rf path
    Waveform.generate(tempname, path, width: 18000)
    FileUtils.rm tempname
    image = MiniMagick::Image.open(path)
    image.rotate(90)
    image.write(path)
    song.update(wave_form_singer: "#{id}_singer.png")
  rescue Exception => e
    p e
  end
end
