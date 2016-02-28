require 'dropbox_sdk'

ACCESS_TOKEN = ENV['dropbox_access_token']
$client = DropboxClient.new(ACCESS_TOKEN)
