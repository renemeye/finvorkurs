class RenameCourseToTestOnQuerstions < ActiveRecord::Migration
  def up
		rename_column :questions, :course_id, :test_id
  end

  def down
		rename_column :questions, :test_id, :course_id
  end
end
