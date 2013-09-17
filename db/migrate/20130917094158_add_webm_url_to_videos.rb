class AddWebmUrlToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :webm_url, :string
  end
end
