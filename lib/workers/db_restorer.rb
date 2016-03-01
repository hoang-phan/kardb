require 'open-uri'
require 'csv'

class DbRestorer
  include Sidekiq::Worker

  def perform(link)
    Patch.delete_all

    CSV.parse(open(link).read, headers: true).each do |row|
      patch = Patch.create(version: row['version'].to_i, link: row['link'])
      PatchRestorer.perform_async(patch.id)
    end
  rescue Exception => e
    p e
  end
end
