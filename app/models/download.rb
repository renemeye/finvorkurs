class Download < ActiveRecord::Base
  attr_accessible :name, :url, :file

  mount_uploader :file, DownloadUploader
end
