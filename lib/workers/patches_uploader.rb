require 'csv'

class PatchesUploader
  include Sidekiq::Worker

  def perform
    CSV.open(file_name = "patches.csv", "w") do |w|
      w << %w(version link)
      Patch.find_each do |patch|
        w << [patch.version, patch.link]
      end
    end

    begin
      $client.file_delete("/#{file_name}")
    rescue
      p 'File is ready'
    end
    $client.put_file("/#{file_name}", open(file_name))
    $client.shares "/#{file_name}"
  rescue Exception => e
    p e
  end
end
