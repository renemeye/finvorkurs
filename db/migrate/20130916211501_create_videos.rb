class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :mediaweb_url

      t.timestamps
    end
  end
end
