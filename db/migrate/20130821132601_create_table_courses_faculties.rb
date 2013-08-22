class CreateTableCoursesFaculties < ActiveRecord::Migration
  def up
		create_table :faculties_courses, :id => false do |t|
			t.references :course, :faculty
		end
		add_index :faculties_courses, [:course_id, :faculty_id]
  end

  def down
		remove_table :faculties_courses
  end
end
