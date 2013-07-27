class RenameTestToVorkursTestColumns < ActiveRecord::Migration
  def up
		rename_column :questions, :test_id, :vorkurs_test_id
		rename_column :test_results, :test_id, :vorkurs_test_id
  end

  def down
		rename_column :questions, :vorkurs_test_id, :test_id
		rename_column :test_results, :vorkurs_test_id, :test_id
  end
end
