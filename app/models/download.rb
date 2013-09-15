class Download < ActiveRecord::Base
  attr_accessible :name, :url, :file, :remote_file_url

  mount_uploader :file, DownloadUploader
end
