class RenameTestsToVorkursTests < ActiveRecord::Migration
  def up
		rename_table :tests, :vorkurs_tests
  end

  def down
		rename_table :vorkurs_tests, :tests
  end
end
