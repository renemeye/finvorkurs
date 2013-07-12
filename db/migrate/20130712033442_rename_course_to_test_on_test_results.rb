class RenameCourseToTestOnTestResults < ActiveRecord::Migration
  def up
		rename_column :test_results, :course_id, :test_id
  end

  def down
		rename_column :test_results, :test_id, :course_id
  end
end
