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

    $client.put_file("/#{file_name}", open(file_name))
  rescue Exception => e
    p e
  end
end
