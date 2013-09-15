class AddFileToDownload < ActiveRecord::Migration
  def change
    add_column :downloads, :file, :string
  end
end
